import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import Process 1.0
import QtQuick.Window 2.2
import Qt.labs.folderlistmodel 2.0

ApplicationWindow {
    id: window
    x: 0
    y: 0
    color: 'white'
    visible: true
    visibility: "FullScreen"
    flags: Qt.FramelessWindowHint
    title: 'RasPad Launcher'

    property string setlang
    property string settime
    property int iconGridWidth: 178
    property int iconGridHeight: 200
    property int iconWidth: 130
    property int iconHeight: 130
    property bool systemApplicationsFolderListDone: false
    property bool userApplicationsFolderListDone: false
    property bool isLoadApplicationTriggered: false

    property int lang
    property string langName: ""
    property var appData: {}
    property var categoriedAppList: {
        "Home": ["Scratch 3", "Ezblock Studio", "Chromium Web Browser", "Minecraft Pi", "mu", "LibreOffice Writer", "LibreOffice Calc", "LibreOffice Impress", "File Manager PCManFM", "LXTerminal", "FAQ"],
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
        "Programming": ["Development", "IDE", "ComputeSicence"],
        "Education": ["Education", "Science", "Math"],
        "Office": ["Office"],
        "Internet": ["Network", "WebBrowser", "Email", "RemoteAccess"],
        "SoundNVideo": ["AudioVideo", "Player", "Recorder", "Audio", "Video", "Midi", "X-Alsa", "X-Jack"],
        "Graphics": ["Graphics", "2DGraphics", "Phtography"],
        "Games": ["Game"],
        "Accessories": ["System", "Utility", "Archiving", "Compression", "ConsoleOnly", "Qt", "PackageManager", "FileTools", "FileManager", "TextEditor"],
        "Help": ["Help"],
        "Preferences": ["Settings"]
    }
    property var blacklist: ["Squeak", "Wolfram"]
    property var whitelist: ["Screen Configuration", "Bookshelf"]
    property var currentCategory: "Home"

    property string errorNetwork: qsTr("Network Error")

    // Set language after everythings done
    Component.onCompleted: {
        var l = Qt.locale().name.substring(0,2);
        // log(l);
        if (l == "zh") {
            lang = 1;
        } else {
            lang = 0;
        }
        language.setLanguage(lang);
    }

    // Panel
    Rectangle {
        id: panel
        width: 242
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
            width: 222
            clip: true
            interactive: false
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
                        // language.setLanguage(lang);
                    } else {
                        reloadAppList(model.name);
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
                        process.start("lxde-pi-shutdown-helper", [])
                        timer.start()
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
                                result = "file://" + appIcon
                            }
                            return result
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
                            var arguments = appData[appName].appParam
                            process.setProgram(appExec)
                            process.setArguments(arguments)
                            process.startDetached()
                            killTimer.start()
                        }
                    }
                    Timer {
                        id: killTimer
                        interval: 500
                        running: false
                        onTriggered: {
                            // log("killTimer: Kill myself")
                            processkill.start("killall", ["raspad-launcher"])
                        }
                    }
                    Process {
                        id: processkill
                    }
                }
            }
            Component.onCompleted: reloadAppList(qsTr("Home"))
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
            // language.setLanguage(lang)
        }
    }

    // 系统安装APP的文件获取模型
    FolderListModel {
        id: systemApplicationsFolderList
        folder: "file:///usr/share/applications"
        nameFilters: ["*.desktop"]
        Component.onCompleted: {
            loadApplicationTimer.start();
        }
    }
    // 用户安装APP的文件获取模型
    FolderListModel {
        id: userApplicationsFolderList
        folder: "file:///home/pi/.local/share/applications"
        nameFilters: ["*.desktop"]
        Component.onCompleted: {
            loadApplicationTimer.start();
        }
    }

    function loadFromFolderListModel(folderList) {
        // log("loadFromFolderListModel(")
        // logFolderList(folderList)
        // log(")")
        var all_categories = [];
        var desktops = [];
        for (var i = 0; i < folderList.count; i++) {
            var url = folderList.get(i, "fileURL");
            // if (! url.endsWith(".desktop")){
            //     log("Ignore: " + url)
            //     continue
            // }
            var result = readFile(url, true);

            if (result === false) {
                // log("Read file Error: " + url);
                continue;
            }

            var contents = result.split("\n");
            var name = "";
            var localName = "";
            var genericName = "";
            var displayName = "";
            var icon = "";
            var exec = "";
            var param = [];
            var categories = [];
            var desktopType = "";
            var isShow = true;
            var isWhiteListed = false;

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
                var temp = line.split("=");
                var arg = temp[0];
                var value = line.split(arg + "=")[1];
                // log(langName);
                if (arg === "Name") {
                    name = value;
                } else if (arg === "Name[" + langName + "]") {
                    localName = value;
                } else if (arg === "GenericName[" + langName + "]") {
                    localName = value;
                } else if (arg === "GenericName") {
                    genericName = value;
                } else if (arg === "Categories") {
                    categories = value.split(";");
                    for (var k = 0; k < categories.length; k++) {
                        var category = categories[k];
                        if (category === "") {
                            continue;
                        }
                        if (all_categories.indexOf(category) === -1) {
                            all_categories.push(category)
                        }
                    }
                } else if (arg === "Icon") {
                    icon = value;
                } else if (arg === "Exec") {
                    exec = value;
                    if (exec.indexOf(",") !== -1) {
                        exec = exec.split(",");
                        param = exec.slice(1);
                        exec = exec[0];
                    } else if (exec.indexOf(" ") !== -1) {
                        exec = exec.split(" ");
                        param = exec.slice(1);
                        exec = exec[0];
                    }
                    var newParam = [];
                    for (var paramI = 0; paramI < param.length; paramI++) {
                        if (!param[paramI].startsWith("%")) {
                            newParam.push(param[paramI]);
                        }
                    }
                    param = newParam;
                } else if (arg === "Terminal") {
                    if (value === "true") {
                        isShow = false;
                    }
                } else if (arg === "NoDisplay") {
                    // log("NoDisplay true: " + url);
                    if (value === "true") {
                        isShow = false;
                    }
                } else if (arg === "NotShowIn") {
                    if (value === "GNOME;KDE;XFCE;MATE;") {
                        isShow = false;
                    }
                }
            }
            url = url.toString().slice(7);
            displayName = name;
            // if (genericName !== "" && genericName.length < 25){
            //     displayName = genericName;
            // }
            if (localName !== "") {
                displayName = localName;
            }
            if (blacklist.indexOf(name) !== -1) {
                isShow = false;
            }
            if (whitelist.indexOf(name) !== -1) {
                isWhiteListed = true;
                // log("White List: " + name);
            }
            if (!isShow && !isWhiteListed) {
                // log("Terminal App, Skip: " + url);
                continue;
            }
            var added = false;
            appData[name] = {
                "appName": name,
                "displayName": displayName,// Todo: add display name translation
                "appCategories": categories,
                "appIcon": icon,
                "appUrl": url,
                "appExec": exec,
                "appParam": param
            }
            // log("appData[" + name + "]:")
            // logObj(appData[name]);
            // log("categories.length: " + categories.length);
            // log("categories: ");
            // logList(categories);

            for (var l = 0; l < categories.length; l++) {
                for (category in categoryRule) {
                    if (categoryRule[category].indexOf(categories[l]) !== -1 && categoriedAppList[category].indexOf(name) === -1) {
                        categoriedAppList[category].push(name);
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
        reloadAppList();
    }
    function isFileExist(path) {
        var xhr = new XMLHttpRequest()
        xhr.open("GET", path, false)
        xhr.send()
        if (xhr.readyState !== 4) {
            return false
        }
        if (xhr.status !== 200) {
            return false
        }
        return true
    }
    function getIconPath(icon) {
        var testList = [
            "/usr/share/icons/PiXflat/256x256/apps/",
            "/usr/share/icons/PiXflat/128x128/apps/",
            "/usr/share/icons/PiXflat/64x64/apps/",
            "/usr/share/icons/PiXflat/48x48/apps/",
            "/usr/share/icons/PiXflat/256x256/devices/",
            "/usr/share/icons/PiXflat/128x128/devices/",
            "/usr/share/icons/PiXflat/64x64/devices/",
            "/usr/share/icons/PiXflat/48x48/devices/",
            "/usr/share/icons/PiXflat/256x256/places/",
            "/usr/share/icons/PiXflat/128x128/places/",
            "/usr/share/icons/PiXflat/64x64/places/",
            "/usr/share/icons/PiXflat/48x48/places/",
            "/usr/share/icons/PiXflat/256x256/categories/",
            "/usr/share/icons/PiXflat/128x128/categories/",
            "/usr/share/icons/PiXflat/64x64/categories/",
            "/usr/share/icons/PiXflat/48x48/categories/",
            "/usr/share/icons/hicolor/256x256/apps/",
            "/usr/share/icons/hicolor/128x128/apps/",
            "/usr/share/icons/hicolor/64x64/apps/",
            "/usr/share/icons/hicolor/48x48/apps/",
            "/usr/share/icons/hicolor/32x32/apps/",
            "/usr/share/icons/gnome/256x256/apps/",
            "/usr/share/icons/gnome/128x128/apps/",
            "/usr/share/icons/gnome/64x64/apps/",
            "/usr/share/icons/gnome/48x48/apps/",
            "/usr/share/icons/gnome/256x256/devices/",
            "/usr/share/icons/gnome/128x128/devices/",
            "/usr/share/icons/gnome/64x64/devices/",
            "/usr/share/icons/gnome/48x48/devices/",
            "/usr/share/pixmaps/"
        ];
        for (var i = 0; i < testList.length; i++) {
            var path = "file://" + testList[i] + icon + ".png"
            if (isFileExist(path)) {
                return path
            }
        }
        return false
    }
    function reloadAppList(name) {
        // log("reloadAppList(" + name + ")");
        // language.setLanguage(lang);
        if (name !== undefined) {
            appDrawLabelText.text = name;
        }
        appDrawList.clear();
        // log("loader.visible: " + loader.visible)
        if (loader.visible) {
            loadApplicationTimer.start();
            loader.visible = false;
            loader.source = "";
            appDraw.visible = true;
        } else {
            var programs = categoriedAppList[currentCategory];
            // log("programs: " + programs);
            // log("programs.length: " + programs.length);
            for (var i = 0; i < programs.length; i++) {
                var appName = programs[i];
                var app = appData[appName];
                // log("app:");
                // logObj(app);
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
            log("Param: " + app.appParam);
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
            base = "file:///home/pi/.config/raspad/"
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

    // To load icons from folder list
    Timer {
        id: loadApplicationTimer
        interval: 500
        running: false
        onTriggered: {
            if (isLoadApplicationTriggered) {
                return;
            }
            // if systemApplicationsFolderList is not Ready, Try again
            if (systemApplicationsFolderList.status !== FolderListModel.Ready) {
                loadApplicationTimer.start();
                return;
            }
            // if userApplicationsFolderList is not Ready, Try again
            if (userApplicationsFolderList.status !== FolderListModel.Ready) {
                loadApplicationTimer.start();
                return;
            }
            isLoadApplicationTriggered = true;
            appData = {};
            loadFromFolderListModel(systemApplicationsFolderList);
            loadFromFolderListModel(userApplicationsFolderList);
            isLoadApplicationTriggered = false;
        }
    }

    // To kill itself after launcher an application
    Timer {
        id: timer
        interval: 100
        running: false
        onTriggered: {
            process.start("killall", ["raspad-launcher"])
        }
    }

    // For running command
    Process {
        id: process
    }

}
