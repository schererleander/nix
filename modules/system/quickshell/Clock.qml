import QtQuick
import QtQuick.Layouts
import Quickshell

Item {
    id: root
    width: clock.implicitWidth
    height: parent.height

    Text {
        id: clock
        anchors.verticalCenter: parent.verticalCenter
        color: Theme.text
        text: Qt.formatDateTime(new Date(), "ddd d MMM  HH:mm:ss")
        font {
            family: Theme.mainFont
            pixelSize: 13
            weight: Font.Medium
        }

        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: clock.text = Qt.formatDateTime(new Date(), "ddd d MMM  HH:mm:ss")
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: GlobalState.toggle("NotificationHistory")
    }

    AnchoredPopup {
        popupName: "NotificationHistory"
        anchorWindow: barWindow
        anchorItem: root

        PopupCard {
            width: 360
            maxHeight: 520
            margins: 14

            RowLayout {
                Layout.fillWidth: true
                Layout.leftMargin: 4
                Layout.rightMargin: 4
                spacing: 8

                Text {
                    text: "Notifications"
                    color: Theme.text
                    font {
                        family: Theme.mainFont
                        pixelSize: 14
                        weight: Font.DemiBold
                    }
                }

                Item {
                    Layout.fillWidth: true
                }

                Text {
                    visible: GlobalState.notificationHistory.length > 0
                    text: "Clear"
                    color: clearArea.containsMouse ? Theme.text : Theme.textMuted
                    font {
                        family: Theme.mainFont
                        pixelSize: 12
                        weight: Font.Medium
                    }

                    MouseArea {
                        id: clearArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: GlobalState.clearNotificationHistory()
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                color: Theme.border
            }

            Text {
                visible: GlobalState.notificationHistory.length === 0
                Layout.fillWidth: true
                Layout.topMargin: 20
                Layout.bottomMargin: 20
                horizontalAlignment: Text.AlignHCenter
                text: "No notifications"
                color: Theme.textMuted
                font {
                    family: Theme.mainFont
                    pixelSize: 13
                    weight: Font.Medium
                }
            }

            Repeater {
                model: GlobalState.notificationHistory

                delegate: Squircle {
                    id: historyItem
                    required property var modelData

                    Layout.fillWidth: true
                    Layout.preferredHeight: Math.max(64, historyLayout.implicitHeight + 20)
                    cornerRadius: 12
                    fillColor: historyHover.containsMouse ? Theme.surfaceHover : Theme.surface
                    strokeColor: Theme.border
                    strokeWidth: 1

                    MouseArea {
                        id: historyHover
                        anchors.fill: parent
                        hoverEnabled: true
                        acceptedButtons: Qt.NoButton
                    }

                    RowLayout {
                        id: historyLayout
                        anchors {
                            fill: parent
                            margins: 10
                        }
                        spacing: 10

                        IconCircle {
                            size: 32
                            source: "notifications"
                            active: false
                            Layout.alignment: Qt.AlignTop
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 2

                            RowLayout {
                                Layout.fillWidth: true

                                Text {
                                    Layout.fillWidth: true
                                    text: historyItem.modelData.nAppName || "Notification"
                                    color: Theme.textMuted
                                    elide: Text.ElideRight
                                    font {
                                        family: Theme.mainFont
                                        pixelSize: 11
                                        weight: Font.Medium
                                    }
                                }

                                Text {
                                    text: Qt.formatTime(historyItem.modelData.nTimestamp, "HH:mm")
                                    color: Theme.textPlaceholder
                                    font {
                                        family: Theme.mainFont
                                        pixelSize: 10
                                    }
                                }
                            }

                            Text {
                                visible: text !== ""
                                Layout.fillWidth: true
                                text: historyItem.modelData.nSummary || ""
                                color: Theme.text
                                elide: Text.ElideRight
                                maximumLineCount: 1
                                font {
                                    family: Theme.mainFont
                                    pixelSize: 13
                                    weight: Font.DemiBold
                                }
                            }

                            Text {
                                visible: text !== ""
                                Layout.fillWidth: true
                                text: historyItem.modelData.nBody || ""
                                color: Theme.textMuted
                                wrapMode: Text.WordWrap
                                maximumLineCount: 2
                                elide: Text.ElideRight
                                textFormat: Text.StyledText
                                font {
                                    family: Theme.mainFont
                                    pixelSize: 12
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
