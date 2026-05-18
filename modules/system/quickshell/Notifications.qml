import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications
import QtQuick

Scope {
    id: scope

    readonly property int defaultTimeout: 5000

    property int nextId: 0
    property var liveNotifs: ({})

    ListModel { id: popupModel }

    function removeNotificationData(id) {
        for (let i = 0; i < popupModel.count; i++) {
            if (popupModel.get(i).nId === id) {
                popupModel.remove(i)
                break
            }
        }
        delete liveNotifs[id]
    }

    function dismissExplicitly(id) {
        const n = liveNotifs[id]
        if (n) n.dismiss()
        removeNotificationData(id)
    }

    function hidePopup(id) {
        for (let i = 0; i < popupModel.count; i++) {
            if (popupModel.get(i).nId === id) {
                popupModel.remove(i)
                break
            }
        }
    }

    function activateById(id) {
        const n = liveNotifs[id]
        if (!n) return

        let invoked = false
        for (const action of n.actions) {
            if (action.identifier === "default") {
                action.invoke()
                invoked = true
                break
            }
        }
        if (!invoked && n.desktopEntry) {
            Quickshell.execDetached(["gtk-launch", n.desktopEntry])
        }
        dismissExplicitly(id)
    }

    function invokeAction(id, identifier) {
        const n = liveNotifs[id]
        if (n) {
            for (const action of n.actions) {
                if (action.identifier === identifier) {
                    action.invoke()
                    break
                }
            }
        }
        dismissExplicitly(id)
    }

    function sendReply(id, text) {
        const n = liveNotifs[id]
        if (n && n.hasInlineReply) n.sendInlineReply(text)
        dismissExplicitly(id)
    }

    NotificationServer {
        keepOnReload: false
        actionsSupported: true
        actionIconsSupported: true
        bodySupported: true
        bodyMarkupSupported: true
        bodyImagesSupported: true
        imageSupported: true
        inlineReplySupported: true
        persistenceSupported: true

        onNotification: notif => {
            notif.tracked = true

            const id = nextId
            nextId = nextId + 1
            liveNotifs[id] = notif

            const acts = []
            let hasDefault = false
            for (const a of notif.actions) {
                if (a.identifier === "default") hasDefault = true
                else acts.push({ identifier: a.identifier, text: a.text })
            }

            notif.closed.connect(() => removeNotificationData(id))

            let formattedAppIcon = notif.appIcon || ""
            if (formattedAppIcon !== "") {
                if (formattedAppIcon.startsWith("file://")) {
                } else if (formattedAppIcon.startsWith("/")) {
                    formattedAppIcon = "file://" + formattedAppIcon
                } else {
                    formattedAppIcon = `image://icon/${formattedAppIcon}`
                }
            }

            let formattedImage = notif.image || ""
            if (formattedImage !== "" && formattedImage.startsWith("/")) {
                formattedImage = "file://" + formattedImage
            }

            const data = {
                nId: id,
                nSummary: notif.summary,
                nBody: notif.body,
                nAppName: notif.appName || "Notification",
                nAppIcon: formattedAppIcon,
                nImage: formattedImage,
                nTimestamp: new Date(),
                nTimeout: notif.expireTimeout > 0 ? notif.expireTimeout : defaultTimeout,
                nActions: acts,
                nClickable: hasDefault || (notif.desktopEntry || "") !== "",
                nHasInlineReply: notif.hasInlineReply || false,
                nReplyPlaceholder: notif.inlineReplyPlaceholder || "Reply",
                nResident: notif.resident || false
            }

            popupModel.insert(0, data)
        }
    }

    NotificationPopupList {
        popupModel: scope.popupModel
        onActionInvoked: (id, identifier) => scope.invokeAction(id, identifier)
        onReplySent: (id, text) => scope.sendReply(id, text)
        onDismissed: id => scope.dismissExplicitly(id)
        onActivated: id => scope.activateById(id)
        onHideRequested: id => scope.hidePopup(id)
    }
}

