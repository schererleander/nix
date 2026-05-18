import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland 

PanelWindow {
    id: root

    // Properties
    property string networkName: ""
    property string title: "The Wi-Fi network \"" + networkName + "\" requires a password."
    property string submitLabel: "Join"
    property string iconSource: "network-wireless-symbolic"
    
    signal submitted(string text, bool remember)
    signal cancelled()

    // Methods
    function open(name) {
        networkName = name
        passwordInput.text = ""
        showPasswordCheck.checked = false
        rememberNetworkCheck.checked = true
        visible = true
        Qt.callLater(() => passwordInput.forceActiveFocus())
    }

    // Window Configuration
    visible: false
    color: Theme.transparent
    exclusiveZone: 0
    
    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }
    
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

    HyprlandFocusGrab {
        id: focusGrab
        windows: [root]
        active: root.visible
    }

    // UI Layout
    Rectangle {
        anchors.fill: parent
        color: Theme.scrim
        MouseArea { 
            anchors.fill: parent 
            acceptedButtons: Qt.AllButtons
            hoverEnabled: true
            onWheel: wheel => wheel.accepted = true
        }
    }

    Squircle {
        id: dialog
        anchors.centerIn: parent
        width: 480
        height: Math.max(180, layout.implicitHeight + 40)
        fillColor: Theme.bg
        strokeColor: Theme.border
        strokeWidth: 1
        cornerRadius: 12

        Keys.onEscapePressed: {
            root.visible = false
            root.cancelled()
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
                    source: Quickshell.iconPath(root.iconSource)
                    fillMode: Image.PreserveAspectFit
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 8

                Text {
                    Layout.fillWidth: true
                    text: root.title
                    color: Theme.text
                    font.pixelSize: 13
                    font.weight: Font.DemiBold
                    wrapMode: Text.WordWrap
                }

                GridLayout {
                    Layout.fillWidth: true
                    columns: 2
                    rowSpacing: 8
                    columnSpacing: 8

                    Text {
                        text: "Password:"
                        color: Theme.text
                        font.pixelSize: 12
                        Layout.alignment: Qt.AlignRight | Qt.AlignTop
                        Layout.topMargin: 6
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        TextField {
                            id: passwordInput
                            focus: true
                            Layout.fillWidth: true
                            Layout.preferredHeight: 28
                            font.pixelSize: 12
                            color: Theme.text
                            echoMode: showPasswordCheck.checked ? TextInput.Normal : TextInput.Password
                            
                            background: Rectangle {
                                color: Theme.surface
                                radius: 4
                                border.color: passwordInput.activeFocus ? Theme.accent : Theme.border
                                border.width: passwordInput.activeFocus ? 2 : 1
                            }

                            onAccepted: {
                                root.submitted(passwordInput.text, rememberNetworkCheck.checked)
                                root.visible = false
                            }
                        }

                        CustomCheckBox {
                            id: showPasswordCheck
                            text: "Show password"
                            Layout.fillWidth: true
                        }

                        CustomCheckBox {
                            id: rememberNetworkCheck
                            text: "Remember this network"
                            checked: true
                            Layout.fillWidth: true
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
                            root.visible = false
                            root.cancelled()
                        }
                    }

                    Button {
                        text: root.submitLabel
                        
                        contentItem: Text {
                            text: parent.text
                            color: Theme.text
                            font.pixelSize: 13
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        
                        background: Rectangle {
                            implicitWidth: 80
                            implicitHeight: 28
                            color: parent.hovered ? Theme.accentHover : Theme.accent
                            radius: 6
                        }
                        
                        onClicked: {
                            root.submitted(passwordInput.text, rememberNetworkCheck.checked)
                            root.visible = false
                        }
                    }
                }
            }
        }
    }
}
