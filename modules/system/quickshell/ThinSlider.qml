import QtQuick
import QtQuick.Controls

Slider {
    id: root

    readonly property color colorTrack: Theme.sliderTrack
    readonly property color colorProgress: Theme.accent
    readonly property color colorHandle: Theme.sliderHandle

    implicitHeight: 14
    padding: 0

    background: Rectangle {
        x: root.leftPadding
        y: root.topPadding + root.availableHeight / 2 - height / 2
        implicitWidth: 200
        implicitHeight: 2
        width: root.availableWidth
        height: implicitHeight
        radius: height / 2
        color: root.colorTrack

        Rectangle {
            width: root.handle.x + (root.handle.width / 2)
            height: parent.height
            color: root.colorProgress
            radius: height / 2
        }
    }

    handle: Rectangle {
        x: root.leftPadding + root.visualPosition * (root.availableWidth - width)
        y: root.topPadding + root.availableHeight / 2 - height / 2
        implicitWidth: 2
        implicitHeight: 10
        radius: width / 2
        color: root.colorHandle
    }
}
