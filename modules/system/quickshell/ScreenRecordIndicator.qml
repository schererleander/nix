import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Item {
    id: root
    width: indicator.width
    height: parent.height
    visible: root.recording

    readonly property bool recording: {
        const nodes = Pipewire.nodes?.values || [];
        for (const node of nodes) {
            if (node && node.isStream && (node.type & PwNodeType.VideoSource))
                return true;
        }
        return false;
    }

    Squircle {
        id: indicator
        anchors.verticalCenter: parent.verticalCenter
        width: 28
        height: 22
        cornerRadius: 8
        fillColor: Theme.destructive

        Image {
            anchors.centerIn: parent
            width: 15
            height: 15
            source: Quickshell.iconPath("media-record-symbolic")
            sourceSize: Qt.size(width, height)
            smooth: true
            mipmap: true
        }
    }
}
