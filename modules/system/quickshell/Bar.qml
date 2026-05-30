import Quickshell
import Quickshell.Wayland
import Quickshell.Services.SystemTray
import QtQuick

PanelWindow {
    id: barWindow

    WlrLayershell.layer: WlrLayer.Top

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: Theme.barHeight
    color: Theme.barBg

    Item {
        anchors.fill: parent
        anchors.leftMargin: 12
        anchors.rightMargin: 12

        Workspaces {
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
            }
        }

        Row {
            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
            }
            spacing: 14

            Repeater {
                model: SystemTray.items

                delegate: Image {
                    id: trayIcon
                    required property SystemTrayItem modelData

                    width: 16
                    height: 16
                    anchors.verticalCenter: parent.verticalCenter
                    source: modelData.icon
                    sourceSize: Qt.size(width, height)
                    smooth: true
                    mipmap: true

                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        onClicked: mouse => {
                            if (mouse.button === Qt.RightButton) {
                                if (modelData.hasMenu && modelData.menu) {
                                    trayMenu.menuItem = modelData.menu;
                                    trayMenu.open(trayIcon);
                                }
                            } else {
                                modelData.activate();
                            }
                        }
                    }
                }
            }

            TrayMenu {
                id: trayMenu
                parentWindow: barWindow
            }

            Bluetooth {
                anchors.verticalCenter: parent.verticalCenter
            }

            Wifi {
                anchors.verticalCenter: parent.verticalCenter
            }

            Volume {
                anchors.verticalCenter: parent.verticalCenter
            }

            ScreenRecordIndicator {
                anchors.verticalCenter: parent.verticalCenter
            }

            MicInput {
                anchors.verticalCenter: parent.verticalCenter
            }

            Media {
                anchors.verticalCenter: parent.verticalCenter
            }

            ControlCenter {
                anchors.verticalCenter: parent.verticalCenter
            }

            Clock {
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}
