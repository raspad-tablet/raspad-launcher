// Provide functions to read the $HOME and $XDG_DATA_* environment variables
// and to collect all existing subdirs of paths in $XDG_DATA_*.
// This javascript resource is only meant to be imported by main.qml as it
// requires the objects enviroment and fileinfo from ApplicationWindow window.

    function getHomeDir() {
        var homeDir = environment.getenv("HOME");
        if (homeDir === "") {
            // Use default.
            homeDir = "/home/pi";
        }
        return homeDir;
    }

    function getXDGDataHomeDir() {
        var dataHomeDir = environment.getenv("XDG_DATA_HOME");
        if (dataHomeDir === "") {
            // Use default according to "XDG Base Directory Specification".
            dataHomeDir = getHomeDir() + "/.local/share";
        }
        return dataHomeDir;
    }

    function getXDGConfigHomeDir() {
        var configHomeDir = environment.getenv("XDG_CONFIG_HOME");
        if (configHomeDir === "") {
            // Use default according to "XDG Base Directory Specification".
            configHomeDir = getHomeDir() + "/.config";
        }
        return configHomeDir;
    }

    function getXDGDataDirs() {
        var dataDirs = environment.getenv("XDG_DATA_DIRS");
        if (dataDirs === "") {
            // Use default according to "XDG Base Directory Specification".
            dataDirs = "/usr/local/share:/usr/share";
        }
        return dataDirs;
    }

    // Get list of all existing directories of the form $XDG_DATA_HOME/subdir
    // and $XDG_DATA_DIRS/subdir in the given order of preference.
    function getXDGDataDirsSubdirs(subdir) {
        var baseDirs = [getXDGDataHomeDir()].concat(getXDGDataDirs().split(':'));

        var subdirs = [];
        for (var i = 0; i < baseDirs.length; i++) {
            if (fileinfo.isRelative(baseDirs[i])) {
                // Ignore relative paths according to
                // "XDG Base Directory Specification".
                continue;
            }
            var dir = baseDirs[i] + "/" + subdir;
            if (fileinfo.isDir(dir)) {
                subdirs.push(dir);
            }
        }
        return subdirs
    }
