import QtQuick
import QtQuick.Layouts
import Quickshell

Scope {
    id: root
    property var menuItem: null
    property var parentWindow
    property var anchorItem: null
    property bool active: false

    function open(item) {
        anchorItem = item;
        active = true;
        menuAnchor.open();
    }

    function close() {
        active = false;
        menuAnchor.close();
    }

    QsMenuAnchor {
        id: menuAnchor
        menu: root.menuItem

        anchor.window: root.parentWindow
        anchor.item: root.anchorItem
        anchor.edges: Edges.Bottom
        anchor.gravity: Edges.Bottom
        anchor.margins.top: Theme.popupGap

        onVisibleChanged: {
            if (!visible && root.active) {
                root.active = false;
            }
        }
    }
}
