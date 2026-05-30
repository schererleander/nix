pragma Singleton
import QtQuick

QtObject {
    property string activePopup: ""
    property var notificationHistory: []

    function open(name) {
        activePopup = "";
        activePopup = name;
    }

    function close() {
        activePopup = "";
    }

    function toggle(name) {
        if (activePopup === name)
            activePopup = "";
        else
            activePopup = name;
    }

    function addNotification(data) {
        const entry = Object.assign({}, data);
        notificationHistory = [entry].concat(notificationHistory).slice(0, 50);
    }

    function clearNotificationHistory() {
        notificationHistory = [];
    }
}
