import QtQuick 2.0
import QtQuick.Controls 2.0
import Process 1.0
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
            onClicked: process.start(input.text, []);
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
