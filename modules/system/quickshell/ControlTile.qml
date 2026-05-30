import QtQuick
import QtQuick.Layouts
import Quickshell

Item {
    id: root
    property string icon: ""
    property string label: ""
    property bool active: false
    property var clickHandler: null

    Layout.fillWidth: true
    Layout.preferredHeight: 64

    Squircle {
        anchors.fill: parent
        cornerRadius: 16
        fillColor: root.active ? Theme.accent : Theme.surface

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                if (root.clickHandler)
                    root.clickHandler();
            }
        }

        RowLayout {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 12

            IconCircle {
                source: root.icon
                active: root.active
            }

            Text {
                text: root.label
                color: root.active ? Theme.bg : Theme.text
                font.family: Theme.mainFont
                font.pixelSize: 11
                font.weight: Font.Medium
                elide: Text.ElideRight
                Layout.maximumWidth: 80
                visible: root.label !== ""
            }
        }
    }
}
