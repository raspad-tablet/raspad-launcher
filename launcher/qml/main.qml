import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import Process 1.0
import QtQuick.Window 2.2
import Qt.labs.folderlistmodel 2.0
import QtQuick.Dialogs 1.1
import "execvalueparser.js" as Parser
import FileInfo 1.0
import ProcessEnvironment 1.0
import "xdgdirectories.js" as XDGDirs

ApplicationWindow {
    id: window
    x: 0
    y: 0
    width: Screen.width
    height: Screen.height
    color: 'white'
    flags: Qt.FramelessWindowHint
    title: 'RasPad Launcher'

    onActiveChanged: {
        if (!active) {
            Qt.quit()
        }
    }

    Component.onCompleted: {
        createFolderListModels();
        iconDirs = generateIconSearchDirs();
        loadApplicationTimer.start();
    }

    property string settime
    property int iconGridWidth: 178
    property int iconGridHeight: 200
    property int iconWidth: 130
    property int iconHeight: 130
    property bool userApplicationsFolderListDone: false
    property bool raspiUiOverridesApplicationsFolderListDone: false
    property bool systemApplicationsFolderListDone: false
    property bool isLoadApplicationTriggered: false

    property var appData: {}
    property var categoriedAppList: {
        "Home": ["scratch3.desktop", "Ezblock Studio ???.desktop", "chromium-browser.desktop", "minecraft-pi.desktop", "mu.codewith.editor.desktop", "libreoffice-writer.desktop", "libreoffice-calc.desktop", "libreoffice-impress.desktop", "pcmanfm.desktop", "lxterminal.desktop", "raspad-faq.desktop"],
        "Programming": [],
        "Education": [],
        "Office": [],
        "Internet": [],
        "SoundNVideo": [],
        "Graphics": [],
        "Games": [],
        "Accessories": [],
        "Help": [],
        "Preferences": [],
    }
    // AudioVideo, Development, Education, Game, Graphics, Network, Office, Settings, System, Utility.
    property var categoryRule: {
        "Programming": ["Development", "IDE", "ComputerScience"],
        "Education": ["Education", "Science", "Math"],
        "Office": ["Office"],
        "Internet": ["Network", "WebBrowser", "Email", "RemoteAccess"],
        "SoundNVideo": ["AudioVideo", "Player", "Recorder", "Audio", "Video", "Midi", "X-Alsa", "X-Jack"],
        "Graphics": ["Graphics", "2DGraphics", "Photography"],
        "Games": ["Game"],
        "Accessories": ["System", "Utility", "Archiving", "Compression", "ConsoleOnly", "PackageManager", "FileTools", "FileManager", "TextEditor", "None"],
        "Help": ["Help"],
        "Preferences": ["Settings"]
    }
    property var blacklist: ["wolfram-language.desktop"]
    property var whitelist: []
    property var currentCategory: "Home"

    property string errorNetwork: qsTr("Network Error")

    property var iconDirs: []
    property var appFolderListModels: []

    // Panel
    Rectangle {
        id: panel
        width: listView.width + 20
        height: parent.height
        anchors {
            top: parent.top
            left: parent.left
        }
        color: "#f8db5e"

        Image {
            id: logo
            source: "../images/logo.png"
            width: 32
            height: 32
            anchors {
                top: parent.top
                left: parent.left
                topMargin: 2
                leftMargin: 3
                bottomMargin: 41
            }
            MouseArea {
                anchors.fill: parent
                onClicked: Qt.quit()
            }
        }
        ListModel {
            id: categoryList
            ListElement {
                name: qsTr("Home")
                page: "Home"
                color: "#eac243"
            }
            ListElement {
                name: qsTr("Programming")
                page: "Programming"
                color: "#a9c747"
            }
            ListElement {
                name: qsTr("Education")
                page: "Education"
                color: "#9e389e"
            }
            ListElement {
                name: qsTr("Office")
                page: "Office"
                color: "#e37b65"
            }
            ListElement {
                name: qsTr("Internet")
                page: "Internet"
                color: "#57acda"
            }
            ListElement {
                name: qsTr("Sound & Video")
                page: "SoundNVideo"
                color: "#cc2929"
            }
            ListElement {
                name: qsTr("Graphics")
                page: "Graphics"
                color: "#dd7f19"
            }
            ListElement {
                name: qsTr("Games")
                page: "Games"
                color: "#7ca643"
            }
            ListElement {
                name: qsTr("Accessories")
                page: "Accessories"
                color: "#e18831"
            }
            ListElement {
                name: qsTr("Help")
                page: "Help"
                color: "#c02a47"
            }
            ListElement {
                name: qsTr("Preferences")
                page: "Preferences"
                color: "#60badd"
            }
            ListElement {
                name: qsTr("Run")
                page: "Run"
                color: "#975b9d"
            }
        }

        ListView {
            id: listView
            width: 242
            clip: true
            boundsBehavior: Flickable.StopAtBounds
            anchors {
                top: logo.bottom
                left: parent.left
                bottom: powerRow.top
                topMargin: 9
                leftMargin: 3
                bottomMargin: 9
                margins: 2
            }
            ScrollBar.vertical: ScrollBar{}
            model: categoryList
            delegate: Button {
                width: 242
                height: 40
                Image {
                    id: circle
                    width: 32
                    height: 32
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    source: "../images/" + model.page + ".png"
                }
                Text {
                    text: model.name
                    font.bold: true
                    font.pointSize: 12
                    anchors.left: circle.right
                    anchors.leftMargin: 10
                    anchors.verticalCenter: parent.verticalCenter
                }
                onClicked: {
                    // log("Module on click");
                    currentCategory = model.page;
                    // log("currentCategory: "+ currentCategory);
                    if (categoriedAppList[currentCategory] === undefined) {
                        loader.source = model.page.toLowerCase() + ".qml";
                        window.visibility = "Windowed"
                        window.showMaximized()
                    } else {
                        reloadAppList(model.name);
                        window.showFullScreen()
                    }
                }
                background: Rectangle {
                    color: 'transparent'
                }
            }
        }

        Row {
            id: powerRow
            anchors {
                bottom: parent.bottom
                left: parent.left
                margins: 18
                bottomMargin: 18
            }
            spacing: 30
            Rectangle {
                width: 40
                height: 40
                radius: width / 2
                color: "#c02a49" //#df8931"
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        process.setProgram("lxde-pi-shutdown-helper");
                        process.setArguments([]);
                        process.setWorkingDirectoryHome()
                        process.setStandardFilesToNull();

                        if (process.startDetached()) {
                            Qt.quit();
                        }
                    }
                }
                Image {
                    anchors.fill: parent
                    source: "../images/shutdown.png"
                }
            }
        }
    }

    // App Draw
    Rectangle {
        id: appDraw
        anchors {
            left: panel.right
            leftMargin: 2
            top: parent.top
            bottom: parent.bottom
            right: parent.right
        }

        Rectangle {
            id: appDrawLabel
            width: appDrawLabelText.width + 20
            height: 32
            color: "#feda3e"
            radius: 10
            anchors {
                top: parent.top
                left: devideBar.left
                topMargin: 62
            }
        }
        Text {
            id: appDrawLabelText
            anchors.centerIn: appDrawLabel
            text: qsTr("Recommend:")
            font.pointSize: 10
            font.bold: true
        }
        Rectangle {
            id: devideBar
            width: grid.width - (iconGridWidth - iconWidth)
            height: 2
            anchors {
                horizontalCenter: grid.horizontalCenter
                top: appDrawLabel.bottom
                rightMargin: 20
            }
            color: "#feda3e"
        }

        ListModel {
            id: appDrawList
        }
        GridView {
            id: grid
            width: Math.floor(
                (window.width - panel.width) / iconGridWidth) * iconGridWidth
            cellWidth: iconGridWidth
            cellHeight: iconGridHeight
            clip: true
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: appDrawLabel.bottom
                bottom: parent.bottom
                topMargin: 30
                bottomMargin: 62
            }
            ScrollBar.vertical: ScrollBar{}
            model: appDrawList
            delegate: Column {
                Rectangle {
                    width: iconWidth
                    height: iconHeight
                    color: "#fdf6d0"
                    radius: 10
                    x: (iconGridWidth - iconWidth) / 2
                    y: (iconGridHeight - iconHeight) / 2
                    Text {
                        width: parent.width - 10
                        anchors {
                            top: appButtonIcon.bottom
                            topMargin: 2
                            bottom: parent.bottom
                            bottomMargin: 5
                            horizontalCenter: parent.horizontalCenter
                        }
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        color: "#3d3b39"
                        text: displayName
                        wrapMode: Text.WordWrap
                        font.pointSize: 10
                        // Rectangle {
                        //     anchors.fill: parent
                        //     color: "black"
                        // }
                    }

                    Image {
                        id: appButtonIcon
                        width: 64
                        height: 64
                        source: {
                            var result = ""
                            if (appIcon.indexOf("/") === -1) {
                                var _icon = getIconPath(appIcon)
                                if (!_icon) {
                                    log("Load Icon: cannot found icon: " + appIcon)
                                    return ""
                                }
                                result = _icon
                            } else {
                                result = appIcon
                            }
                            return "file://" + result
                        }
                        anchors {
                            horizontalCenter: parent.horizontalCenter
                            top: parent.top
                            topMargin: 15
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            // log("Icon on click" + JSON.stringify(categoriedAppList[currentCategory][appName]));
                            var result = Parser.parseCommandLine(appData[appName])
                            if (result.length === 0) {
                                messageBox.text = qsTr("Desktop file '%1'\ncontains no valid Exec line!").arg(appUrl);
                                messageBox.open();
                                return;
                            }
                            var executable = result[0];
                            var args = result.slice(1);
                            if (!fileinfo.exexcutableFileExists(executable)) {
                                messageBox.text = qsTr("Invalid desktop file: '%1'").arg(appUrl);
                                messageBox.open();
                                return;
                            }
                            if (appInTerminal) {
                                executable = "lxterminal"
                                args = result;
                                args.unshift("-e");
                            }
                            process.setProgram(executable);
                            process.setArguments(args);
                            if (appPath) {
                                process.setWorkingDirectory(appPath);
                            } else {
                                process.setWorkingDirectoryHome()
                            }
                            // Detach process from current stdin, stdout,
                            // stderr, so that especially console programs
                            // don't clutter the console of our launcher.
                            process.setStandardFilesToNull();

                            if (process.startDetached()) {
                               Qt.quit();
                            } else {
                               messageBox.text = qsTr("Error starting command of desktop file: '%1'").arg(appUrl);
                               messageBox.open();
                            }
                        }
                    }
                }
            }
            Component.onCompleted: reloadAppList(qsTr(currentCategory))
        }
    }

    // To load qml page instead of app drawer
    Loader {
        id: loader
        anchors {
            left: panel.right
            leftMargin: 2
            top: parent.top
            bottom: parent.bottom
            right: parent.right
        }
        visible: false
        onLoaded: {
            // log("Load source: " + loader.source);
            loader.visible = true
            appDraw.visible = false
        }
    }

    MessageDialog {
        id: messageBox
        title: window.title
        icon: StandardIcon.Critical
        modality: Qt.ApplicationModal
    }

    Component {
        id: folderListModelComponent

        // 系统安装APP的文件获取模型
        // 用户安装APP的文件获取模型
        FolderListModel {
             nameFilters: ["*.desktop"]
        }
    }

    function loadFromFolderListModel(folderList) {
        // log("loadFromFolderListModel(")
        // logFolderList(folderList)
        // log(")")
        var curDesktops = environment.getenv("XDG_CURRENT_DESKTOP").split(';');

        var all_categories = [];
        var desktops = [];
        for (var i = 0; i < folderList.count; i++) {
            var url = folderList.get(i, "fileURL");
            // if (! url.endsWith(".desktop")){
            //     log("Ignore: " + url)
            //     continue
            // }
            var filePath = url.toString().slice(7);
            var urllist = filePath.split("/")
            var fileID = urllist[urllist.length - 1];
            if (appData[fileID]) {
                // application fileID has been already seen.
                continue;
            }
            var result = readFile(url, true);

            if (result === false) {
                // log("Read file Error: " + url);
                continue;
            }
            url = filePath;

            var contents = result.split("\n");
            var map = {};
            var desktopType = "";

            for (var j = 0; j < contents.length; j++) {
                var line = contents[j];
                // filter comment lines
                if (line.startsWith("#")) {
                    continue;
                }
                // get current desktop type
                if (line.startsWith("[") && line.endsWith("]")) {
                    desktopType = line;
                    continue;
                }
                // if current type is not Desktop Entry, then pass.
                if (desktopType !== "[Desktop Entry]") {
                    continue;
                }
                var equalPos = line.indexOf('=');
                if (equalPos === -1) {
                    continue;
                }
                var arg = line.slice(0, equalPos);
                var value = line.slice(equalPos + 1);
                map[arg] = value;
            }

            if (map["Type"] !== "Application") {
                continue;
            }

            // Use "uncategorized" category, in case no categories are given.
            var categories = ["None"];
            if (map["Categories"]) {
                categories = map["Categories"].split(";");
                for (var k = 0; k < categories.length; k++) {
                    var category = categories[k];
                    if (category !== "") {
                        if (all_categories.indexOf(category) === -1) {
                            all_categories.push(category)
                        }
                    }
                }
            }
            var icon = map["Icon"] ? map["Icon"] : '';
            var exec = map["Exec"] ? map["Exec"] : '';
            var path = map["Path"] ? map["Path"] : '';

            var isShow = true;
            var onlyShowIn = map["OnlyShowIn"];
            if (onlyShowIn) {
                isShow = false;
                for (var k = 0; k < curDesktops.length; k++) {
                    if (onlyShowIn.indexOf(curDesktops[k]) !== -1) {
                        isShow = true;
                        break;
                    }
                }
            }
            var notShowIn = map["NotShowIn"];
            if (notShowIn) {
                for (var k = 0; k < curDesktops.length; k++) {
                    if (notShowIn.indexOf(curDesktops[k]) !== -1) {
                        isShow = false;
                        break;
                    }
                }
            }

            if (map["TryExec"]) {
                if (!fileinfo.exexcutableFileExists(map["TryExec"])) {
                    isShow = false;
                }
            }
            var inTerminal = map["Terminal"] === "true";
            if (map["NoDisplay"] === "true") {
                isShow = false;
            }

            var locale = Qt.locale().name;
            var lang = locale.substring(0,2);

            var displayName = map["Name[" + locale + "]"];
            if (!displayName) {
                displayName = map["Name[" + lang + "]"];
            }
            if (!displayName) {
                displayName = map["Name"];
            }
            if (!displayName) {
                displayName = map["GenericName[" + locale + "]"];
            }
            if (!displayName) {
                displayName = map["GenericName[" + lang + "]"];
            }
            if (!displayName) {
                displayName = map["GenericName"];
            }
            if (!displayName) {
                isShow = false;
            }

            if (blacklist.indexOf(fileID) !== -1) {
                isShow = false;
            }
            var isWhiteListed = whitelist.indexOf(fileID) !== -1;

            var added = false;
            appData[fileID] = {
                "appName": fileID,
                "displayName": displayName,
                "appCategories": categories,
                "appIcon": icon,
                "appUrl": url,
                "appExec": exec,
                "appPath": path,
                "appInTerminal": inTerminal,
                "appIsShow" : isShow || isWhiteListed
            }
            // log("appData[" + fileID + "]:")
            // logObj(appData[fileID]);
            // log("categories.length: " + categories.length);
            // log("categories: ");
            // logList(categories);

            for (var l = 0; l < categories.length; l++) {
                for (category in categoryRule) {
                    if (categoryRule[category].indexOf(categories[l]) !== -1 && categoriedAppList[category].indexOf(fileID) === -1) {
                        categoriedAppList[category].push(fileID);
                        added = true;
                        break;
                    }
                    // log("categoriedAppList[" + category + "]");
                    // logList(categoriedAppList[category]);
                }
                if (added) {
                    break;
                }
            }
            // logList(categoriedAppList)
        }
        // log("categoriedAppList")
        // logObj(categoriedAppList)
    }

    function generateIconSearchDirs() {
        var iconDirs = []
        var iconBaseDirs = XDGDirs.getXDGDataDirsSubdirs("icons");

        for (var i = 0; i < iconBaseDirs.length; i++) {
            var themes = ["PiXflat", "hicolor", "gnome"];

            for (var j = 0; j < themes.length; j++) {
                var themeDir = iconBaseDirs[i] + "/" + themes[j];
                if (!fileinfo.isDir(themeDir)) {
                    continue;
                }
                var sections = ["apps", "devices", "places" , "categories", "status"];

                for (var k = 0; k < sections.length; k++) {
                    var resolutions = ["256x256", "128x128", "64x64",
                                       "48x48", "32x32", "scalable"];

                    for (var l = 0; l < resolutions.length; l++) {
                        var iconDir = themeDir + "/" + resolutions[l]
                                           + "/" + sections[k] + "/";
                        if (fileinfo.isDir(iconDir)) {
                            iconDirs.push(iconDir);
                        }
                    }
                }
            }
        }
        iconDirs.push("/usr/share/pixmaps/");
        // log("iconDirs (" + iconDirs.length + ")")
        // logList(iconDirs);

        return iconDirs;
    }

    function getIconPath(icon) {
        for (var i = 0; i < iconDirs.length; i++) {
            var path_pre = iconDirs[i] + icon
            var path = path_pre
            if (icon.indexOf(".png") == -1 && icon.indexOf(".svg") == -1) {
                path = path_pre + ".png"
                if (fileinfo.isFile(path)) {
                    return path
                }
                path = path_pre + ".svg"
            }
            if (fileinfo.isFile(path)) {
                return path
            }
        }
        return false
    }
    function reloadAppList(name) {
        // log("reloadAppList(" + name + ")");
        if (name !== undefined) {
            appDrawLabelText.text = name;
        }
        appDrawList.clear();
        // log("loader.visible: " + loader.visible)
        if (loader.visible) {
            loader.visible = false;
            loader.source = "";
            appDraw.visible = true;
        }
        if (!appData) {
            return;
        }
        var programs = categoriedAppList[currentCategory];
        // log("programs: " + programs);
        // log("programs.length: " + programs.length);
        for (var i = 0; i < programs.length; i++) {
            var appName = programs[i];
            var app = appData[appName];
            // log("app:");
            // logObj(app);
            if (app && app.appIsShow) {
                appDrawList.append(app);
            }
        }
    }

    function logCategory(cate){
        log("Log categore: "+ cate);
        var check = categoriedAppList[cate];
        for (var i=0; i<check.length; i++){
            app = appData[check[i]];
            log("Name: " + app.appName);
            log("Categories: " + app.appCategories);
            log("Icon: " + app.appIcon);
            log("Exec: " + app.appExec);
            log("Path: " + app.appPath);
            log("Terminal: " + app.appInTerminal);
            log("isShow: " + app.appIsShow);
        }
    }

    function log(msg) {
        var DEBUG = false;
        if (DEBUG) {
            console.log(msg);
        }
    }

    function logFolderList(li){
        log("[")
        for (var i=0; i<li.count; i++){
            log("  " + li.get(i, "fileURL") + ",")
        } 
        log("]")
    }
    function logList(li){
        log("[")
        for (var i=0; i<li.length; i++){
            log("  " + li[i] + ",")
        } 
        log("]")
    }

    function logObj(obj){
        log("{")
        for (var name in obj){
            log("  " + name + " = " + obj[name] + ",")
        } 
        log("}")
    }

    // To Read file
    function readFile(file, raw) {
        var base = ""
        if (raw !== true) {
            base = "file://" + XDGDirs.getXDGConfigHomeDir() + "/raspad/"
        }
        var read = new XMLHttpRequest()
        read.open("GET", base + file, false)
        read.send()
        if (read.status !== 200) {
            return false
        }
        var result = read.responseText
        return result
    }

    function createFolderListModels() {
        var appFolders = XDGDirs.getXDGDataDirsSubdirs("applications");
        // log("appFolders");
        // logList(appFolders);

        appFolderListModels = [];
        for (var i = 0; i < appFolders.length; i++) {
             var appFolderListModel =
                                folderListModelComponent.createObject(window,
                                          {folder: 'file://' + appFolders[i]})
             if (appFolderListModel !== null) {
                 appFolderListModels.push(appFolderListModel);
             }
             else {
                 console.log('Could not create FolderListModel for folder',
                             appFolders[i]);
             }
        }
    }

    // Load *.desktop files from folder lists.
    Timer {
        id: loadApplicationTimer
        interval: 1
        running: false
        onTriggered: {
            if (isLoadApplicationTriggered) {
                return;
            }
            for (var i = 0; i < appFolderListModels.length; i++) {
                // if any FolderListModel is not Ready, Try again
                if (appFolderListModels[i].status !== FolderListModel.Ready) {
                    loadApplicationTimer.start();
                    return;
                }
            }
            isLoadApplicationTriggered = true;
            appData = {};
            for (var i = 0; i < appFolderListModels.length; i++) {
                loadFromFolderListModel(appFolderListModels[i]);
            }
            reloadAppList();
            visibility = "FullScreen";
            isLoadApplicationTriggered = false;
        }
    }

    // For running command
    Process {
        id: process
    }
    // For finding command
    FileInfo {
        id: fileinfo
    }
    // For accessing the environment
    ProcessEnvironment {
        id: environment
    }

}
