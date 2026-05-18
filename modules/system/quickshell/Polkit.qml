import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Polkit

PanelWindow {
    id: root

    PolkitAgent {
        id: agent
        
        Component.onCompleted: console.log("PolkitAgent status: " + (isRegistered ? "Registered" : "Not Registered"))
        onIsRegisteredChanged: console.log("PolkitAgent registration changed: " + isRegistered)
        
        onIsActiveChanged: {
            console.log("PolkitAgent active state: " + isActive)
            if (isActive) {
                root.visible = true;
                passwordInput.text = "";
                Qt.callLater(() => passwordInput.forceActiveFocus());
            } else {
                root.visible = false;
            }
        }
    }

    visible: false
    color: Theme.transparent
    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }
    exclusiveZone: 0
    
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: visible ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

    Rectangle {
        anchors.fill: parent
        color: Theme.scrim
        MouseArea { 
            anchors.fill: parent
            onClicked: {
                if (agent.flow) {
                    agent.flow.cancelAuthenticationRequest();
                }
            }
        }
    }

    Squircle {
        id: dialog
        anchors.centerIn: parent
        width: 480
        height: Math.max(220, layout.implicitHeight + 40)
        fillColor: Theme.bg
        strokeColor: Theme.border
        strokeWidth: 1
        cornerRadius: 12

        MouseArea {
            anchors.fill: parent
            onClicked: (mouse) => mouse.accepted = true
        }

        RowLayout {
            id: layout
            anchors.fill: parent
            anchors.margins: 20
            spacing: 16

            Item {
                Layout.alignment: Qt.AlignTop
                Layout.preferredWidth: 64
                Layout.preferredHeight: 64
                
                Image {
                    anchors.fill: parent
                    source: agent.flow ? Quickshell.iconPath(agent.flow.iconName || "dialog-password-symbolic") : ""
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    mipmap: true
                    sourceSize: Qt.size(64, 64)
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 12

                Text {
                    Layout.fillWidth: true
                    text: agent.flow ? agent.flow.message : ""
                    color: Theme.text
                    font.family: Theme.mainFont
                    font.pixelSize: 13
                    font.weight: Font.DemiBold
                    wrapMode: Text.WordWrap
                }

                Text {
                    visible: agent.flow && agent.flow.supplementaryMessage !== ""
                    Layout.fillWidth: true
                    text: agent.flow ? agent.flow.supplementaryMessage : ""
                    color: (agent.flow && agent.flow.supplementaryIsError) ? Theme.destructive : Theme.textDim
                    font.family: Theme.mainFont
                    font.pixelSize: 12
                    wrapMode: Text.WordWrap
                }

                GridLayout {
                    Layout.fillWidth: true
                    columns: 2
                    rowSpacing: 8
                    columnSpacing: 8
                    visible: agent.flow && agent.flow.isResponseRequired

                    Text {
                        text: agent.flow ? agent.flow.inputPrompt : "Password:"
                        color: Theme.text
                        font.family: Theme.mainFont
                        font.pixelSize: 12
                        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                    }

                    TextField {
                        id: passwordInput
                        Layout.fillWidth: true
                        Layout.preferredHeight: 28
                        font.family: Theme.mainFont
                        font.pixelSize: 12
                        color: Theme.text
                        echoMode: (agent.flow && agent.flow.responseVisible) ? TextInput.Normal : TextInput.Password
                        
                        background: Rectangle {
                            color: Theme.surface
                            radius: 4
                            border.color: passwordInput.activeFocus ? Theme.accent : Theme.border
                            border.width: passwordInput.activeFocus ? 2 : 1
                        }

                        onAccepted: {
                            if (agent.flow) {
                                agent.flow.submit(passwordInput.text);
                                passwordInput.text = "";
                            }
                        }
                    }
                }

                Item { Layout.preferredHeight: 4 } 

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8

                    Item { Layout.fillWidth: true } 

                    Button {
                        text: "Cancel"
                        
                        contentItem: Text {
                            text: parent.text
                            color: Theme.text
                            font.family: Theme.mainFont
                            font.pixelSize: 13
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        
                        background: Rectangle {
                            implicitWidth: 80
                            implicitHeight: 28
                            color: parent.hovered ? Theme.surfaceHover : Theme.surface
                            radius: 6
                            border.color: Theme.border
                            border.width: 1
                        }
                        
                        onClicked: {
                            if (agent.flow) {
                                agent.flow.cancelAuthenticationRequest();
                            }
                        }
                    }

                    Button {
                        enabled: agent.flow && (!agent.flow.isResponseRequired || passwordInput.text !== "")
                        text: "Authenticate"
                        
                        contentItem: Text {
                            text: parent.text
                            color: enabled ? Theme.text : Theme.textDisabled
                            font.pixelSize: 13
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        
                        background: Rectangle {
                            implicitWidth: 100
                            implicitHeight: 28
                            color: parent.enabled ? (parent.hovered ? Theme.accentHover : Theme.accent) : Theme.surface
                            radius: 6
                        }
                        
                        onClicked: {
                            if (agent.flow) {
                                agent.flow.submit(passwordInput.text);
                                passwordInput.text = "";
                            }
                        }
                    }
                }
            }
        }
    }
}
