import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Squircle {
    id: root

    readonly property int maxHeight: 440
    property int margins: 16
    default property alias content: contentCol.data

    width: 320
    height: Math.min(Math.max(contentCol.implicitHeight + 2 * margins, 80), maxHeight)

    Behavior on height {
        SpringAnimation { spring: 3; damping: 0.25 }
    }

    fillColor: Theme.bg
    strokeColor: Theme.border
    strokeWidth: 1
    cornerRadius: 20
    clip: true

    ScrollView {
        anchors {
            fill: parent
            margins: root.margins
        }
        clip: true
        contentWidth: availableWidth
        ScrollBar.vertical.policy: contentCol.implicitHeight > height
            ? ScrollBar.AsNeeded
            : ScrollBar.AlwaysOff

        ColumnLayout {
            id: contentCol
            width: parent.width
            spacing: 12
        }
    }
}
