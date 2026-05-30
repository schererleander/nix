import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import Quickshell

Slider {
    id: root

    property string icon: ""
    property color colorTrack: Theme.sliderTrack
    property color colorProgress: Theme.accent
    property color colorHandle: "#FFFFFF"
    property color iconColor: Theme.iconDefault

    implicitHeight: 24
    padding: 0

    background: Rectangle {
        width: root.width
        height: root.height
        radius: height / 2
        color: root.colorTrack

        clip: true

        Rectangle {
            width: root.handle.x + (root.handle.width / 2)
            height: parent.height
            color: root.colorProgress
        }

        Image {
            id: iconImage
            visible: root.icon !== ""
            anchors.left: parent.left
            anchors.leftMargin: 6
            anchors.verticalCenter: parent.verticalCenter
            source: root.icon !== "" ? Quickshell.iconPath(root.icon) : ""
            sourceSize: Qt.size(14, 14)
            width: 14
            height: 14
        }

        MultiEffect {
            source: iconImage
            anchors.fill: iconImage
            colorizationColor: root.iconColor
            colorization: 1.0
        }
    }

    handle: Item {
        x: root.visualPosition * (root.availableWidth - width)
        y: root.topPadding + root.availableHeight / 2 - height / 2

        width: root.height
        height: root.height

        Rectangle {
            id: handleCircle
            anchors.fill: parent
            radius: width / 2
            color: root.colorHandle
            border.width: 1
            border.color: "#1A000000"
        }

        MultiEffect {
            source: handleCircle
            anchors.fill: handleCircle
            shadowEnabled: true
            shadowBlur: 1.0
            shadowColor: "#4D000000"
            shadowVerticalOffset: 1
        }
    }
}
