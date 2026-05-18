import QtQuick

// iOS-style on/off switch. `checked` is the visual state; the parent
// owns truth and handles `toggled` by flipping it. Uses Item.enabled
// for the disabled visual + input gating.
Rectangle {
    id: root
    property bool checked: false
    signal toggled()

    width: 40
    height: 22
    radius: 11
    color: checked ? Theme.accent : Theme.sliderTrack
    opacity: enabled ? 1.0 : 0.4

    Rectangle {
        width: 18
        height: 18
        radius: 9
        color: Theme.text
        anchors { verticalCenter: parent.verticalCenter }
        x: root.checked ? parent.width - width - 2 : 2
        Behavior on x { NumberAnimation { duration: 150 } }
    }

    MouseArea {
        anchors { fill: parent }
        onClicked: root.toggled()
    }
}
