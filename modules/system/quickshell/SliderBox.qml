import QtQuick
import QtQuick.Layouts
import Quickshell

Squircle {
    id: root
    property string label: ""
    property string icon: ""
    property real value: 0
    signal moved(real val)

    Layout.fillWidth: true
    height: 64
    cornerRadius: 16
    fillColor: hoverArea.containsMouse ? Theme.surfaceHover : Theme.surface

    MouseArea {
        id: hoverArea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.NoButton
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
            Item { Layout.fillWidth: true }
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
