import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

Item {
    id: root
    required property LockContext context
    focus: true

    property bool showInput: false
    property string realName: ""

    Process {
        id: nameProc
        command: ["sh", "-c", "NAME=$(getent passwd $USER | cut -d: -f5 | cut -d, -f1); if [ -n \"$NAME\" ]; then echo \"$NAME\"; else whoami; fi"]
        running: true
        stdout: SplitParser {
            onRead: line => {
                root.realName = line.trim()
            }
        }
    }

    // Capture keyboard input to reveal the text field
    Keys.onPressed: (event) => {
        if (!showInput && event.key !== Qt.Key_Escape) {
            showInput = true
            passwordInput.forceActiveFocus()
            if (event.text !== "") {
                passwordInput.text = event.text
                root.context.currentText = event.text
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            root.showInput = true
            passwordInput.forceActiveFocus()
        }
    }

    Image {
        anchors.fill: parent
        source: "./wallpaper.jpg"
        fillMode: Image.PreserveAspectCrop
    }

    // Main Content (Clock)
    Column {
        anchors {
            top: parent.top
            topMargin: 120
            horizontalCenter: parent.horizontalCenter
        }
        spacing: 0
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: Qt.formatDateTime(new Date(), "dddd, MMMM d")
            color: "white"
            opacity: 0.9
            font {
                family: Theme.mainFont
                pixelSize: 24
                weight: Font.Medium
            }
        }
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: Qt.formatDateTime(new Date(), "HH:mm")
            color: "white"
            font {
                family: Theme.mainFont
                pixelSize: 150
                weight: Font.DemiBold
                letterSpacing: -8
            }
        }    }

    // Profile and Password Area (Bottom Center)
    ColumnLayout {
        id: passwordContainer
        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
            bottomMargin: 100
        }
        spacing: 15

        SequentialAnimation {
            id: shakeAnimation
            NumberAnimation { target: passwordContainer; property: "anchors.horizontalCenterOffset"; to: -6; duration: 30; easing.type: Easing.OutQuad }
            NumberAnimation { target: passwordContainer; property: "anchors.horizontalCenterOffset"; to: 6; duration: 60; easing.type: Easing.InOutQuad }
            NumberAnimation { target: passwordContainer; property: "anchors.horizontalCenterOffset"; to: -6; duration: 60; easing.type: Easing.InOutQuad }
            NumberAnimation { target: passwordContainer; property: "anchors.horizontalCenterOffset"; to: 6; duration: 60; easing.type: Easing.InOutQuad }
            NumberAnimation { target: passwordContainer; property: "anchors.horizontalCenterOffset"; to: -6; duration: 60; easing.type: Easing.InOutQuad }
            NumberAnimation { target: passwordContainer; property: "anchors.horizontalCenterOffset"; to: 6; duration: 60; easing.type: Easing.InOutQuad }
            NumberAnimation { target: passwordContainer; property: "anchors.horizontalCenterOffset"; to: 0; duration: 30; easing.type: Easing.InQuad }
        }

        Connections {
            target: root.context
            function onFailed() {
                shakeAnimation.start();
            }
        }

        // Avatar Placeholder
        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            width: 60
            height: 60
            radius: 30
            color: "#b0b0b0"
        }

        // User Name
        Text {
            Layout.alignment: Qt.AlignHCenter
            text: root.realName || "User"
            color: "white"
            font {
                family: Theme.mainFont
                pixelSize: 16
                weight: Font.DemiBold
            }
            visible: !root.showInput
        }

        // Prompt Text
        Text {
            Layout.alignment: Qt.AlignHCenter
            text: "Enter Password"
            color: "white"
            opacity: 0.7
            font {
                family: Theme.mainFont
                pixelSize: 13
            }
            visible: !root.showInput
        }

        // Password Input Field
        TextField {
            id: passwordInput
            Layout.preferredWidth: 220
            Layout.preferredHeight: 32
            Layout.alignment: Qt.AlignHCenter
            visible: root.showInput
            
            placeholderText: root.context.pamMessage || "Enter Password"
            placeholderTextColor: Theme.textPlaceholder
            echoMode: TextInput.Password
            inputMethodHints: Qt.ImhSensitiveData
            enabled: !root.context.unlockInProgress
            
            // Update context when text is changed directly in this field
            onTextChanged: root.context.currentText = this.text
            
            // Sync text from context to support multi-monitor mirroring securely
            Connections {
                target: root.context
                function onCurrentTextChanged() {
                    if (passwordInput.text !== root.context.currentText) {
                        passwordInput.text = root.context.currentText;
                    }
                }
            }
            
            background: Rectangle {
                radius: height / 2
                color: Theme.surface
                border.color: parent.activeFocus ? Theme.accent : Theme.border
                border.width: 1
            }

            color: Theme.text
            font.pixelSize: 13
            horizontalAlignment: TextInput.AlignHCenter
            verticalAlignment: TextInput.AlignVCenter

            onAccepted: {
                root.context.tryUnlock()
            }

            Keys.onEscapePressed: {
                root.showInput = false
                root.context.currentText = ""
                root.forceActiveFocus()
            }
        }
    }
}
