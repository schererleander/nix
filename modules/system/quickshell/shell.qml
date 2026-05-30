//@ pragma UseQApplication
import Quickshell
import QtQuick
import Quickshell.Io
import Quickshell.Wayland

ShellRoot {
    Component.onCompleted: {
        Qt.application.font.family = "Inter";
        Qt.application.font.hintingPreference = Font.PreferNoHinting;
        Qt.application.font.styleStrategy = Font.NoSubpixelAntialias;
    }

    Variants {
        model: Quickshell.screens

        Bar {
            required property var modelData
            screen: modelData
        }
    }

    Variants {
        model: Quickshell.screens

        Background {
            required property var modelData
            screen: modelData
        }
    }

    Notifications {}

    VolumeOSD {}
    Polkit {}
    Launcher {}

    LockContext {
        id: lockContext
        onUnlocked: {
            sessionLock.locked = false;
        }
    }

    WlSessionLock {
        id: sessionLock

        WlSessionLockSurface {
            LockSurface {
                anchors.fill: parent
                context: lockContext
            }
        }
    }

    IpcHandler {
        target: "bar"
        function toggleLauncher() {
            GlobalState.toggle("Launcher");
        }

        function lock() {
            lockContext.reset();
            sessionLock.locked = true;
        }
    }
}
