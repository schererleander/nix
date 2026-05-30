import QtQuick
import Quickshell
import Quickshell.Services.Pam

Scope {
    id: root
    signal unlocked
    signal failed

    property string currentText: ""
    property bool unlockInProgress: false
    property string pamMessage: ""
    property bool pamError: false

    onCurrentTextChanged: {
        pamError = false;
        pamMessage = "";
    }

    function tryUnlock() {
        if (currentText === "" || unlockInProgress)
            return;
        unlockInProgress = true;
        pam.start();
    }

    function reset() {
        currentText = "";
        pamError = false;
        pamMessage = "";
        unlockInProgress = false;
    }

    PamContext {
        id: pam
        configDirectory: "pam"
        config: "password.conf"

        onPamMessage: {
            root.pamMessage = pam.message;
            root.pamError = pam.messageIsError;
            if (this.responseRequired) {
                this.respond(root.currentText);
            }
        }

        onCompleted: result => {
            if (result == PamResult.Success) {
                root.currentText = "";
                root.unlocked();
            } else {
                root.currentText = "";
                root.pamError = true;
                root.failed();
            }
            root.unlockInProgress = false;
        }
    }
}
