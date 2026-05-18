import QtQuick
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root
    property var popupModel

    signal actionInvoked(int id, string identifier)
    signal replySent(int id, string text)
    signal dismissed(int id)
    signal activated(int id)
    signal hideRequested(int id)

    visible: popupList.count > 0

    anchors { top: true; right: true }
    WlrLayershell.margins.top: Theme.barHeight
    exclusionMode: ExclusionMode.Ignore
    color: "transparent"
    
    readonly property int edgeMargin: 12
    readonly property int animationSafeMargin: 80
    readonly property int popupWidth: 400

    implicitWidth: popupWidth + edgeMargin * 2 + animationSafeMargin
    implicitHeight: popupList.contentHeight + edgeMargin * 2

    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

    ListView {
        id: popupList
        anchors {
            top: parent.top
            right: parent.right
            topMargin: edgeMargin
            rightMargin: edgeMargin
        }

        width: popupWidth
        height: contentHeight
        spacing: 8
        model: root.popupModel
        interactive: false
        clip: false
        
        delegate: NotificationCard {
            onActionInvoked: (id, identifier) => root.actionInvoked(id, identifier)
            onReplySent: (id, text) => root.replySent(id, text)
            onDismissed: id => root.dismissed(id)
            onActivated: id => root.activated(id)
            onHideRequested: id => root.hideRequested(id)
        }

        add: Transition {
            ParallelAnimation {
                NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 250; easing.type: Easing.OutSine }
                NumberAnimation { property: "x"; from: popupWidth + edgeMargin; duration: 350; easing.type: Easing.OutBack }
            }
        }

        remove: Transition {
            ParallelAnimation {
                NumberAnimation { property: "opacity"; from: 1; to: 0; duration: 200; easing.type: Easing.InSine }
                NumberAnimation { property: "x"; to: popupWidth + edgeMargin; duration: 200; easing.type: Easing.InSine }
            }
        }

        displaced: Transition {
            NumberAnimation { properties: "x,y"; duration: 250; easing.type: Easing.OutSine }
        }
    }
}


