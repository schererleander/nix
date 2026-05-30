import QtQuick
import QtQuick.Layouts
import Quickshell

Squircle {
    id: root
    property string label: ""
    property string icon: ""
    property real value: 0
    property bool clickable: false
    signal moved(real val)
    signal clicked

    Layout.fillWidth: true
    height: 64
    cornerRadius: 16
    fillColor: hoverArea.containsMouse ? Theme.surfaceHover : Theme.surface

    MouseArea {
        id: hoverArea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: root.clickable ? Qt.LeftButton : Qt.NoButton
        cursorShape: root.clickable ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: root.clicked()
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 4

        RowLayout {
            Layout.fillWidth: true
            Text {
                text: root.label
                color: Theme.textMuted
                font {
                    family: Theme.mainFont
                    pixelSize: 12
                    weight: Font.DemiBold
                }
                Layout.leftMargin: 2
            }
            Item {
                Layout.fillWidth: true
            }
        }

        PillSlider {
            id: slider
            Layout.fillWidth: true
            icon: root.icon
            value: root.value
            onMoved: root.moved(value)
        }
    }
}
