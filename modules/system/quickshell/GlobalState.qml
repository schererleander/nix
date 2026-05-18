import QtQuick

pragma Singleton

// Shared state to coordinate which popup is currently open.
// Ensures only one menu is visible at a time.
QtObject {
    property string activePopup: ""

    function open(name) {
        activePopup = ""
        activePopup = name
    }

    function close() {
        activePopup = ""
    }

    function toggle(name) {
        if (activePopup === name) activePopup = ""
        else activePopup = name
    }
}
