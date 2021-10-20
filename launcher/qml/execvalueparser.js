
// Provide parsing functions for Exec value in desktop files.

.pragma library

/* On a first level translate the two character combinations '\n', '\r', '\s',
 * '\t' and '\\' in NEWLINE, CARRIAGE RETURN, SPACE, TAB and BACKSLASH,
 * respectively.
 */
function  doEscapingFirstLevel(text) {
    var replaced = '';
    for (var i = 0; i < text.length; i++) {
        var ch = ''
        if (text[i] =='\\') {
            if (i === text.length - 1) {
                break;
            }
            i++
            var nextChar = text[i];
            if (nextChar === 'n') {
                ch = '\n';
            } else if (nextChar === 'r') {
                ch = '\r';
            } else if (nextChar === 's') {
                ch = ' ';
            } else if (nextChar === 't') {
                ch = '\t';
            } else if (nextChar === '\\') {
                ch = '\\';
            } else {
                ch = '\\'
                i--;
            }
        } else {
           ch = text[i];
        }
        replaced += ch;
    }
    return replaced;
}

/* Replace Exec Value Field Codes '%i', '%c', '%k' and '%%' by the values
 * explained in
 * https://specifications.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html#exec-variables
 * and remove all other two character combination starting with '%'.
 */
function replaceFieldCodes(text, appDataObj) {
    var replaced = '';
    var i = 0;
    while (i < text.length) {
        var next = text.indexOf('%', i)
        if (next !== -1) {
            var code = '';
            var field = '';
            if (next < text.length - 1) {
                var code = text[next + 1];
            }
            if (code === 'i') {
                field = '--icon ' + appDataObj.appIcon;
            } else if (code === 'c') {
                field = "'" + appDataObj.displayName + "'";
            } else if (code === 'k') {
                var path = appDataObj.appUrl;
                field = path.slice(0, path.lastIndexOf('/'))
            } else if (code === '%') {
                field = '%';
            }
            // $f, %F, %u, %U are not used with a file list and must be
            // removed, as well as all other codes (deprecated and undefined).
            replaced += text.slice(i, next) + field;
            i = next + 2;
        } else {
            replaced += text.slice(i);
            break;
        }
    }
    return replaced;
}

function isWhiteSpace(ch) {
    return ch === ' ' || ch === '\t' || ch === '\n'
}

/* On a second level translate two character escape sequences into one character,
 * respecting quoting and argument splitting at unquoted whitespace.
 */
function doEscapingSecondLevelAndSplitArguments(text) {
    var args = [];
    var arg = '';
    // true, if parsing an argument.
    var inArg = false;
    // quoted == 0, being in an unquoted section.
    // quoted == 1, being in a single quoted section.
    // quoted == 2, being in a double quoted section.
    var quoted = 0;
    for (var i = 0; i < text.length; i++) {
        var ch = text[i];
        if (isWhiteSpace(ch)) {
            if (inArg) {
                if (quoted) {
                    arg += ch;
                } else {
                    args.push(arg);
                    arg = '';
                    inArg = false;
                }
            }
            continue;
        }
        if (!inArg) {
            inArg = true
        }
        if (ch === "'") {
            if (quoted === 0) {
                quoted = 1;
            } else if (quoted === 1) {
                quoted = 0;
            } else { // quoted === 2
                arg += ch;
            }
        } else if (ch === '"') {
            if (quoted === 0) {
                quoted = 2;
            } else if (quoted === 2) {
                quoted = 0;
            } else { // quoted === 1
                arg += ch;
            }
        } else if (ch === '\\') {
            if (quoted === 0) {
                if (i == text.length - 1) {
                    // Invalid Exec value.
                    return ['']
                }
                i++;
                next = text[i];
                if (next !== '\n') {
                    arg += next;
                }
            } else if (quoted === 1) {
                arg += ch;
            } else { // quoted === 2
                if (i == text.length - 1) {
                    // Invalid Exec value.
                    return ['']
                }
                i++;
                var next = text[i];
                if (next === '"' || next === '\\' || next === '$'
                     || next === '`' || next === '\n') {
                    arg += next;
                } else {
                    arg += ch + next;
                }
            }
        } else {
            arg += ch;
        }
    }
    if (quoted) {
        // Invalid Exec value.
        return ['']
    } else {
        if (inArg) {
            args.push(arg)
        }
        return args
    }
}

/* The actual Exec value parsing function.
 * It takes an object from the appData application dictionary of main.qml.
 * Returns the list of translated and splitted arguments.
 * First argument is the executable, and is '' in invalid execValue.
 * Returns an empty list, when execValue just consists of whitespace,
 * or Exec key was not present in desktop file.
 */
function parseCommandLine(appDataObj) {
    var execValue = appDataObj.appExec;
    var escaped1 = doEscapingFirstLevel(execValue);
    var withFields = replaceFieldCodes(escaped1, appDataObj);
    var arguments = doEscapingSecondLevelAndSplitArguments(withFields)
    return arguments
}
