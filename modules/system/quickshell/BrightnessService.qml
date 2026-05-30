import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: root
    property real brightness: 0
    property int maxBrightness: 1

    function update() {
        updateProc.running = true;
    }

    function setBrightness(value) {
        const raw = Math.round(value * maxBrightness);
        Quickshell.execDetached(["brightnessctl", "s", raw.toString()]);
        brightness = value;
    }

    readonly property Process updateProc: Process {
        command: ["sh", "-c", "printf '%s %s\\n' \"$(brightnessctl g)\" \"$(brightnessctl m)\""]
        stdout: SplitParser {
            onRead: data => {
                const parts = data.trim().split(/\s+/);
                if (parts.length >= 2) {
                    const current = parseInt(parts[0]);
                    root.maxBrightness = parseInt(parts[1]);
                    root.brightness = current / root.maxBrightness;
                }
            }
        }
    }

    Component.onCompleted: update()
}
