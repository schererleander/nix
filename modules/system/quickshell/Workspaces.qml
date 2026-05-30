import Quickshell
import Quickshell.Io
import QtQuick

Item {
    id: root

    implicitWidth: row.implicitWidth
    implicitHeight: 32

    ListModel {
        id: workspaceModel
    }

    function updateWorkspaces(json) {
        try {
            const ws = JSON.parse(json);
            workspaceModel.clear();
            ws.forEach(w => workspaceModel.append({
                    wsNum: w.num,
                    wsName: w.name,
                    wsFocused: w.focused
                }));
        } catch (_) {}
    }

    Process {
        id: watcher
        command: ["swaymsg", "-t", "subscribe", "-m", "[\"workspace\"]"]
        running: true

        stdout: SplitParser {
            onRead: _ => {
                if (!refresher.running)
                    refresher.running = true;
            }
        }
    }

    Process {
        id: refresher
        command: ["swaymsg", "-t", "get_workspaces", "-r"]

        property string buf: ""

        stdout: SplitParser {
            onRead: line => refresher.buf += line
        }

        onRunningChanged: {
            if (!running && buf !== "") {
                root.updateWorkspaces(buf);
                buf = "";
            }
        }

        Component.onCompleted: running = true
    }

    Row {
        id: row
        anchors {
            verticalCenter: parent.verticalCenter
        }
        spacing: 2

        Repeater {
            model: workspaceModel

            delegate: Rectangle {
                required property int wsNum
                required property string wsName
                required property bool wsFocused

                width: 26
                height: 26
                color: wsFocused ? Theme.focus : Theme.transparent
                radius: 3

                Text {
                    anchors.centerIn: parent
                    text: wsNum
                    color: Theme.text
                    font.pixelSize: 12
                }

                Process {
                    id: switcher
                    command: ["swaymsg", "workspace", "number", wsNum.toString()]
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        switcher.running = false;
                        switcher.running = true;
                    }
                }
            }
        }
    }
}
