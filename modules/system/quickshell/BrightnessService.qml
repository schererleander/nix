import QtQuick
import Quickshell
import Quickshell.Io

// Simplified brightness service using brightnessctl.
QtObject {
    id: root
    property real brightness: 0
    property int maxBrightness: 1

    function update() {
        updateProc.running = true
    }

    function setBrightness(value) {
        const raw = Math.round(value * maxBrightness)
        Quickshell.execDetached(["brightnessctl", "s", raw.toString()])
        brightness = value
    }

    readonly property Process updateProc: Process {
        command: ["sh", "-c", "brightnessctl g && brightnessctl m"]
        stdout: SplitParser {
            onRead: data => {
                const lines = data.trim().split("\n")
                if (lines.length >= 2) {
                    const current = parseInt(lines[0])
                    root.maxBrightness = parseInt(lines[1])
                    root.brightness = current / root.maxBrightness
                }
            }
        }
    }

    Component.onCompleted: update()
}
