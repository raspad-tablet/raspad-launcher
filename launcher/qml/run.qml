import QtQuick 2.0
import QtQuick.Controls 2.0
import Process 1.0
import "execvalueparser.js" as Parser
//import QtQuick.VirtualKeyboard 2.2
//import QtQuick.VirtualKeyboard.Settings 2.2

Rectangle {
    anchors.left: parent.left
    anchors.leftMargin: 62
    Process {
        id: process
    }
    width: 846
    height: 191
    anchors {
        left: parent.left
        top: parent.top
        topMargin: 80
    }
    Component.onCompleted: input.forceActiveFocus()

    Text {
        id: label
        text: qsTr("Enter the command you want to execute: ")
        anchors {
            top: parent.top
            left: parent.left
        }
        font.pointSize: 15
    }

    TextField {
        id: input
        anchors {
            top: label.bottom
            margins: 20
        }
        width: parent.width - 200
        height: 40
        font.pointSize: 15

        Keys.onEnterPressed: {
            startCommand()
            event.accepted = true
        }
        Keys.onReturnPressed: {
            startCommand()
            event.accepted = true
        }
    }

    Rectangle {
        width: 90
        height: 40
        anchors.top: label.bottom
        anchors.margins: 20
        anchors.left: input.right
        border.color: 'grey'
        radius: 5
        Text {
            anchors.centerIn: parent
            text: "Run"
            font.pointSize: 12
        }
        MouseArea {
            anchors.fill: parent
            onClicked: startCommand()
        }
    }

    function startCommand() {
        var result = Parser.doEscapingSecondLevelAndSplitArguments(input.text)
        if (result.length === 0) {
            messageBox.text = "Text is empty (or only consists of whitespace).";
            messageBox.open();
            return;
        }
        var executable = result[0];
        var args = result.slice(1);
        if (executable === '') {
            messageBox.text = "Invalid command line!";
            messageBox.open();
            return;
        }
        process.setProgram(executable);
        process.setArguments(args);
        process.setWorkingDirectoryHome()
        // Detach process from current stdin, stdout,
        // stderr, so that especially console programs
        // don't clutter the console of our launcher.
        process.setStandardFilesToNull();

        if (process.startDetached()) {
            Qt.quit();
        } else {
           messageBox.text = "Error starting command!";
           messageBox.open();
        }
    }
/*
    InputPanel {
        id: inputPanel
        z: 89
        y: parent.height
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: -62 -242
        states: State {
            name: "visible"
            when: inputPanel.active
            PropertyChanges {
                target: inputPanel
                y: parent.height - inputPanel.height - 80
            }
        }
        transitions: Transition {
            id: inputPanelTransition
            from: ""
            to: "visible"
            reversible: true
            enabled: !VirtualKeyboardSettings.fullScreenMode
            ParallelAnimation {
                NumberAnimation {
                    properties: "y"
                    duration: 250
                    easing.type: Easing.InOutQuad
                }
            }
        }
        Binding {
            target: InputContext
            property: "animating"
            value: inputPanelTransition.running
        }
        //AutoScroller {}
    }
*/
}
