import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell

Item {
    id: card

    required property int nId
    required property string nSummary
    required property string nBody
    required property string nAppName
    required property string nAppIcon
    required property string nImage
    required property var nTimestamp
    required property int nTimeout
    required property var nActions
    required property bool nClickable
    required property bool nHasInlineReply
    required property string nReplyPlaceholder
    required property bool nResident

    property bool hovered: cardHover.containsMouse || closeHover.containsMouse || (replyInput && replyInput.activeFocus)

    readonly property bool hasBottom: (nActions ? nActions.count > 0 : false) || nHasInlineReply

    signal actionInvoked(int id, string identifier)
    signal replySent(int id, string text)
    signal dismissed(int id)
    signal activated(int id)
    signal hideRequested(int id)

    function formatTimeAgo(timestamp) {
        const now = new Date();
        const diffMs = now - timestamp;
        const diffMins = Math.floor(diffMs / 60000);
        const diffHours = Math.floor(diffMs / 3600000);

        if (diffMins < 1) return "Just now";
        if (diffMins < 60) return diffMins + "m ago";
        if (diffHours < 24) return diffHours + "h ago";
        return Qt.formatTime(timestamp, "h:mm p");
    }

    width: ListView.view ? ListView.view.width : 400
    height: contentColumn.implicitHeight + 32
    Behavior on height { NumberAnimation { duration: 200; easing.type: Easing.OutSine } }

    Squircle {
        anchors.fill: parent
        cornerRadius: 16
        fillColor: Theme.surface
        strokeColor: Theme.border
        strokeWidth: 1
    }

    MouseArea {
        id: cardHover
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: nClickable ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: {
            if (nClickable) card.activated(nId)
        }
    }

    ColumnLayout {
        id: contentColumn
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            margins: 16
        }
        spacing: 12

        RowLayout {
            Layout.fillWidth: true
            spacing: 12
            Layout.alignment: Qt.AlignTop

            // LEFT: Icon
            Item {
                width: 44
                height: 44
                Layout.alignment: Qt.AlignVCenter

                Squircle {
                    anchors.fill: parent
                    cornerRadius: 10
                    fillColor: Theme.surfaceLighter
                }

                Image {
                    visible: nAppIcon !== ""
                    anchors.centerIn: parent
                    width: 30; height: 30
                    source: nAppIcon
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                }
            }

            // MIDDLE: Text
            ColumnLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignTop
                spacing: 2

                RowLayout {
                    Layout.fillWidth: true
                    Text {
                        text: nAppName
                        color: Theme.text
                        font {
                            family: Theme.mainFont
                            pixelSize: 12
                            weight: Font.Medium
                        }
                        opacity: 0.8
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }
                    Text {
                        text: card.formatTimeAgo(nTimestamp)
                        color: Theme.text
                        opacity: 0.5
                        font {
                            family: Theme.mainFont
                            pixelSize: 11
                        }

                        Timer {
                            interval: 60000
                            running: true
                            repeat: true
                            onTriggered: parent.text = card.formatTimeAgo(nTimestamp)
                        }
                    }
                }

                Text {
                    visible: nSummary !== ""
                    Layout.fillWidth: true
                    text: nSummary
                    color: Theme.text
                    font {
                        family: Theme.mainFont
                        pixelSize: 14
                        weight: Font.DemiBold
                    }
                    wrapMode: Text.WordWrap
                    maximumLineCount: 2
                    elide: Text.ElideRight
                }

                Text {
                    visible: nBody !== ""
                    Layout.fillWidth: true
                    text: nBody
                    color: Theme.text
                    opacity: 0.85
                    font {
                        family: Theme.mainFont
                        pixelSize: 13
                    }
                    wrapMode: Text.WordWrap
                    maximumLineCount: 3
                    elide: Text.ElideRight
                    textFormat: Text.StyledText
                }
            }

            // RIGHT: Image
            Item {
                visible: nImage !== ""
                width: visible ? 44 : 0
                height: 44
                Layout.alignment: Qt.AlignTop

                Squircle {
                    id: mediaMask
                    anchors.fill: parent
                    cornerRadius: 8
                    fillColor: Theme.text
                    visible: false
                    layer.enabled: true
                    layer.smooth: true
                }

                Image {
                    anchors.fill: parent
                    source: nImage
                    fillMode: Image.PreserveAspectCrop
                    smooth: true
                    asynchronous: true
                    layer.enabled: true
                    layer.effect: MultiEffect {
                        maskEnabled: true
                        maskSource: mediaMask
                        maskThresholdMin: 0.5
                    }
                }
            }
        }

        ColumnLayout {
            id: bottomStack
            Layout.fillWidth: true
            visible: card.hasBottom
            spacing: 8
            Layout.leftMargin: 56 // Align with text

            RowLayout {
                visible: nActions && nActions.count > 0
                Layout.fillWidth: true
                spacing: 8

                Repeater {
                    model: nActions
                    delegate: Item {
                        id: actionBtn
                        required property int index
                        required property string identifier
                        required property string text

                        Layout.fillWidth: true
                        Layout.preferredHeight: 28

                        Squircle {
                            anchors.fill: parent
                            cornerRadius: 6
                            fillColor: actionHover.containsMouse ? Theme.surfaceHover : Theme.surfaceLighter
                            scale: actionHover.pressed ? 0.95 : 1.0
                            Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }
                        }

                        Text {
                            anchors.centerIn: parent
                            text: actionBtn.text
                            color: Theme.text
                            font {
                                family: Theme.mainFont
                                pixelSize: 12
                                weight: Font.Medium
                            }
                        }

                        MouseArea {
                            id: actionHover
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: card.actionInvoked(card.nId, actionBtn.identifier)
                        }
                    }
                }
            }

            Item {
                visible: nHasInlineReply
                Layout.fillWidth: true
                Layout.preferredHeight: 30

                Squircle {
                    anchors.fill: parent
                    cornerRadius: 6
                    fillColor: Theme.surfaceLighter
                }

                TextInput {
                    id: replyInput
                    anchors {
                        left: parent.left; leftMargin: 10
                        right: sendBtn.left; rightMargin: 6
                        top: parent.top; bottom: parent.bottom
                    }
                    verticalAlignment: TextInput.AlignVCenter
                    color: Theme.text
                    font {
                        family: Theme.mainFont
                        pixelSize: 12
                    }
                    clip: true
                    activeFocusOnTab: true

                    Text {
                        visible: replyInput.text === "" && !replyInput.activeFocus
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        text: nReplyPlaceholder
                        color: Theme.text
                        opacity: 0.5
                        font: replyInput.font
                    }

                    Keys.onReturnPressed: if (text.length > 0) { card.replySent(card.nId, text); text = "" }
                    Keys.onEnterPressed:  if (text.length > 0) { card.replySent(card.nId, text); text = "" }
                }

                Item {
                    id: sendBtn
                    anchors {
                        right: parent.right; rightMargin: 4
                        verticalCenter: parent.verticalCenter
                    }
                    width: 22; height: 22
                    opacity: replyInput.text.length > 0 ? 1.0 : 0.4

                    Rectangle {
                        anchors.fill: parent
                        radius: 4
                        color: Theme.text
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "↑"
                        color: Theme.bg
                        font.pixelSize: 14
                        font.weight: Font.DemiBold
                    }

                    MouseArea {
                        anchors.fill: parent
                        enabled: replyInput.text.length > 0
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            card.replySent(card.nId, replyInput.text)
                            replyInput.text = ""
                        }
                    }
                }
            }
        }
    }

    // Close button — top-left, visible on hover
    Rectangle {
        width: 20
        height: 20
        radius: 10
        anchors {
            top: parent.top
            left: parent.left
            topMargin: -6
            leftMargin: -6
        }
        color: Theme.surfaceLighter
        border.color: Theme.border
        border.width: 1
        opacity: card.hovered ? 1.0 : 0.0
        Behavior on opacity { NumberAnimation { duration: 150 } }

        Item {
            anchors.centerIn: parent
            width: 8
            height: 8

            Rectangle {
                anchors.centerIn: parent
                width: parent.width * Math.SQRT2
                height: 1.2
                radius: 0.6
                color: Theme.text
                rotation: 45
                antialiasing: true
            }
            Rectangle {
                anchors.centerIn: parent
                width: parent.width * Math.SQRT2
                height: 1.2
                radius: 0.6
                color: Theme.text
                rotation: -45
                antialiasing: true
            }
        }

        MouseArea {
            id: closeHover
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: card.dismissed(card.nId)
        }
    }

    Timer {
        id: hideTimer
        interval: nTimeout
        running: !nResident
        onTriggered: card.hideRequested(nId)
    }

    Connections {
        target: card
        function onHoveredChanged() {
            if (!nResident) {
                if (card.hovered) hideTimer.stop()
                else hideTimer.restart()
            }
        }
    }
}