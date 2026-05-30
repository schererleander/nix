import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "launcher"
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    WlrLayershell.exclusiveZone: -1

    exclusionMode: ExclusionMode.Ignore

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    implicitWidth: 600
    implicitHeight: 400

    color: "transparent"
    visible: GlobalState.activePopup === "Launcher"

    onVisibleChanged: {
        if (visible) {
            searchInput.forceActiveFocus();
            searchInput.text = "";
        }
    }

    Scope {
        id: internal

        function filterApps(searchText) {
            const search = searchText.toLowerCase();
            const apps = DesktopEntries.applications.values;

            return apps.filter(app => {
                if (app.noDisplay)
                    return false;
                if (!search)
                    return true;

                return app.name.toLowerCase().includes(search) || (app.comment && app.comment.toLowerCase().includes(search));
            });
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.AllButtons
        onClicked: GlobalState.close()
        onWheel: wheel => wheel.accepted = true
    }

    FocusScope {
        width: 600
        height: 400
        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
            topMargin: 200
        }
        focus: true

        Squircle {
            id: launcherContent
            anchors.fill: parent
            cornerRadius: 12
            fillColor: Theme.barBg
            strokeColor: Theme.border
            strokeWidth: 1

            Keys.onEscapePressed: GlobalState.close()

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 8

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 12

                    Image {
                        width: 24
                        height: 24
                        source: Quickshell.iconPath("system-search-symbolic")
                        sourceSize: Qt.size(24, 24)
                        smooth: true
                        mipmap: true
                        opacity: 0.7
                    }

                    TextInput {
                        id: searchInput
                        Layout.fillWidth: true
                        font {
                            family: Theme.mainFont
                            pixelSize: 20
                        }
                        color: Theme.text
                        clip: true

                        focus: true
                        cursorVisible: true
                        selectByMouse: true
                        inputMethodHints: Qt.ImhNoPredictiveText

                        Text {
                            visible: searchInput.text === ""
                            text: "Search Applications..."
                            color: Theme.text
                            opacity: 0.3
                            font: searchInput.font
                        }

                        onTextChanged: resultsList.currentIndex = 0

                        Keys.onPressed: event => {
                            if (event.key === Qt.Key_Down) {
                                resultsList.incrementCurrentIndex();
                                event.accepted = true;
                            } else if (event.key === Qt.Key_Up) {
                                resultsList.decrementCurrentIndex();
                                event.accepted = true;
                            } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                if (resultsList.count > 0 && resultsList.currentIndex >= 0) {
                                    if (resultsList.currentItem) {
                                        resultsList.currentItem.launch();
                                    }
                                }
                                event.accepted = true;
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: Theme.border
                }

                ListView {
                    id: resultsList
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    boundsBehavior: Flickable.StopAtBounds
                    highlightFollowsCurrentItem: true
                    highlightMoveDuration: 150
                    highlightResizeDuration: 0

                    highlight: Squircle {
                        width: resultsList.width
                        height: 44
                        cornerRadius: 8
                        fillColor: Theme.surface
                        z: 1
                    }

                    model: internal.filterApps(searchInput.text)

                    delegate: Squircle {
                        id: delegateRoot
                        required property var modelData
                        required property int index

                        height: 44
                        width: resultsList.width

                        cornerRadius: 8
                        fillColor: "transparent"
                        z: 5

                        function launch() {
                            if (modelData && modelData.execute) {
                                modelData.execute();
                                GlobalState.close();
                            }
                        }

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 12
                            anchors.rightMargin: 12
                            spacing: 12

                            Image {
                                width: 24
                                height: 24
                                source: Quickshell.iconPath(modelData.icon)
                                sourceSize: Qt.size(32, 32)
                                smooth: true
                                mipmap: true
                            }

                            Column {
                                Layout.fillWidth: true
                                Text {
                                    text: delegateRoot.modelData.name
                                    color: Theme.text
                                    font {
                                        family: Theme.mainFont
                                        pixelSize: 14
                                        weight: Font.Medium
                                    }
                                }
                                Text {
                                    visible: delegateRoot.modelData.comment !== ""
                                    text: delegateRoot.modelData.comment
                                    color: Theme.textMuted
                                    font {
                                        family: Theme.mainFont
                                        pixelSize: 11
                                    }
                                    elide: Text.ElideRight
                                    width: parent.width
                                }
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: resultsList.currentIndex = index
                            onClicked: delegateRoot.launch()
                        }
                    }

                    ScrollBar.vertical: ScrollBar {}
                }
            }
        }
    }
}
