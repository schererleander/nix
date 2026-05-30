import QtQuick
import Quickshell
import Quickshell.Wayland

Scope {
    id: root

    property string popupName: ""
    property var anchorWindow
    property var anchorItem
    property int popupGap: Theme.popupGap
    readonly property bool open: GlobalState.activePopup === popupName
    default property alias content: contentRoot.data

    signal opened
    signal closed

    PanelWindow {
        visible: root.open
        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }
        WlrLayershell.layer: WlrLayer.Top
        WlrLayershell.margins.top: Theme.barHeight
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
        exclusionMode: ExclusionMode.Ignore
        color: Theme.transparent

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.AllButtons
            hoverEnabled: true
            onClicked: GlobalState.close()
            onWheel: wheel => wheel.accepted = true
        }
    }

    PopupWindow {
        id: popup
        visible: root.open
        grabFocus: true
        implicitWidth: contentRoot.childrenRect.width
        implicitHeight: contentRoot.childrenRect.height

        anchor {
            window: root.anchorWindow
            item: root.anchorItem
            edges: Edges.Bottom
            gravity: Edges.Bottom
            margins.top: root.popupGap
        }

        color: Theme.transparent

        onVisibleChanged: {
            if (visible) {
                anchor.updateAnchor();
                contentRoot.forceActiveFocus();
                root.opened();
            } else {
                root.closed();
            }
        }

        Item {
            id: contentRoot
            focus: true
            width: childrenRect.width
            height: childrenRect.height

            Keys.onEscapePressed: GlobalState.close()
        }
    }
}
