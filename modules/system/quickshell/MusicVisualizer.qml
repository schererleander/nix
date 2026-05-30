import QtQuick

Row {
    id: root
    property bool active: false
    property color color: Theme.accent
    spacing: 2
    height: 16

    Repeater {
        model: 4
        delegate: Rectangle {
            id: bar
            width: 3
            height: root.active ? 4 + Math.random() * (root.height - 4) : 4
            radius: 1.5
            color: root.color

            Timer {
                running: root.active
                interval: 100 + Math.random() * 200
                repeat: true
                onTriggered: {
                    bar.height = 4 + Math.random() * (root.height - 4);
                }
            }

            Behavior on height {
                NumberAnimation {
                    duration: 150
                    easing.type: Easing.OutCubic
                }
            }
        }
    }
}
