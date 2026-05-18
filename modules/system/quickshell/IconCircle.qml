import QtQuick
import QtQuick.Effects
import Quickshell

Rectangle {
    id: root
    
    property string source: ""
    property bool active: false
    property real size: 24

    width: size
    height: size
    radius: size / 2
    color: active ? Theme.accent : Theme.surfaceLighter

    Image {
        id: iconImage
        anchors.centerIn: parent
        width: parent.width * 0.6
        height: parent.height * 0.6
        source: Quickshell.iconPath(root.source.endsWith("-symbolic") ? root.source : root.source + "-symbolic")
        sourceSize: Qt.size(width, height)
        smooth: true
        mipmap: true
        
        visible: false 
    }

    MultiEffect {
        anchors.fill: iconImage
        source: iconImage
        colorizationColor: "#FFFFFF"
        colorization: 1.0
        
        opacity: root.active ? 1.0 : 0.6
    }
}
