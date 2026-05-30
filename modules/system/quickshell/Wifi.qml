import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Networking
import Quickshell.Widgets

Item {
    id: root

    Scope {
        id: internal

        readonly property var device: {
            if (!Networking.devices)
                return null;
            for (const d of Networking.devices.values || []) {
                if (d && d.scannerEnabled !== undefined)
                    return d;
            }
            return null;
        }

        readonly property var allNetworks: device?.networks ? device.networks.values : []
        readonly property bool hasKnown: hasKnownNetwork()
        readonly property bool hasOther: hasOtherNetwork()
        readonly property var activeNetwork: findActiveNetwork()

        function hasKnownNetwork() {
            for (const n of internal.allNetworks) {
                if (n?.known)
                    return true;
            }
            return false;
        }

        function hasOtherNetwork() {
            for (const n of internal.allNetworks) {
                if (n && !n.known && n.name)
                    return true;
            }
            return false;
        }

        function findActiveNetwork() {
            for (const n of internal.allNetworks) {
                if (n?.connected)
                    return n;
            }
            return null;
        }
    }

    function _getWifiIcon(strength) {
        if (!Networking.wifiEnabled)
            return "network-wireless-offline-symbolic";
        if (!internal.activeNetwork && !internal.device?.enabled)
            return "network-wireless-offline-symbolic";

        const s = strength ?? 0;
        if (s >= 0.75)
            return "network-wireless-signal-excellent-symbolic";
        if (s >= 0.50)
            return "network-wireless-signal-good-symbolic";
        if (s >= 0.25)
            return "network-wireless-signal-ok-symbolic";
        if (s > 0)
            return "network-wireless-signal-weak-symbolic";
        return "network-wireless-signal-none-symbolic";
    }

    function _onNetworkClick(net) {
        if (!net)
            return;
        if (net.connected) {
            net.disconnect();
            return;
        }
        if (net.stateChanging)
            return;
        if (net.known) {
            net.connect();
        } else if ((net.security ?? 0) === 0) {
            net.connect();
        } else {
            pskPrompt.network = net;
            pskPrompt.open(net.name ?? "");
        }
    }

    width: childrenRect.width
    height: parent.height

    Row {
        anchors {
            verticalCenter: parent.verticalCenter
        }
        spacing: 4
        Image {
            width: 20
            height: 20
            source: Quickshell.iconPath(root._getWifiIcon(internal.activeNetwork?.signalStrength ?? 0))
            sourceSize: Qt.size(width, height)
            smooth: true
            mipmap: true
            opacity: !Networking.wifiEnabled ? 0.35 : 1.0
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: mouse => {
            if (mouse.button === Qt.LeftButton) {
                GlobalState.toggle("Wifi");
            } else if (mouse.button === Qt.RightButton) {
                Networking.wifiEnabled = !Networking.wifiEnabled;
            }
        }
    }

    AnchoredPopup {
        popupName: "Wifi"
        anchorWindow: barWindow
        anchorItem: root
        onOpened: if (internal.device)
            internal.device.scannerEnabled = true
        onClosed: if (internal.device?.scannerEnabled)
            internal.device.scannerEnabled = false

        PopupCard {
            id: card
            margins: 16

            RowLayout {
                Layout.fillWidth: true
                Layout.topMargin: 4
                Layout.bottomMargin: 4
                Layout.leftMargin: 8
                Layout.rightMargin: 8
                spacing: 8

                Text {
                    text: "Wi-Fi"
                    color: Theme.text
                    font {
                        family: Theme.mainFont
                        pixelSize: 14
                        weight: Font.DemiBold
                    }
                }

                Item {
                    Layout.fillWidth: true
                }

                Toggle {
                    checked: Networking.wifiEnabled
                    enabled: Networking.wifiHardwareEnabled
                    onToggled: Networking.wifiEnabled = !Networking.wifiEnabled
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                color: Theme.border
                Layout.topMargin: 4
                Layout.bottomMargin: 4
            }

            Text {
                visible: internal.hasKnown
                text: "Known Network"
                color: Theme.textMuted
                font {
                    family: Theme.mainFont
                    pixelSize: 12
                    weight: Font.DemiBold
                }
                Layout.leftMargin: 8
                Layout.topMargin: 2
                Layout.bottomMargin: 2
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2
                visible: internal.hasKnown

                Repeater {
                    model: internal.device?.networks ?? null

                    delegate: Squircle {
                        id: knownItem
                        required property var modelData
                        readonly property bool isConnected: knownItem.modelData?.connected ?? false
                        visible: knownItem.modelData?.known ?? false
                        Layout.fillWidth: true
                        Layout.preferredHeight: visible ? 36 : 0
                        fillColor: knownArea.containsMouse ? Theme.surface : Theme.transparent
                        cornerRadius: 6

                        MouseArea {
                            id: knownArea
                            anchors.fill: parent
                            hoverEnabled: true
                            enabled: !(knownItem.modelData?.stateChanging ?? false)
                            onClicked: root._onNetworkClick(knownItem.modelData)
                        }

                        RowLayout {
                            anchors {
                                fill: parent
                                leftMargin: 8
                                rightMargin: 8
                            }
                            spacing: 12

                            IconCircle {
                                size: 24
                                source: root._getWifiIcon(knownItem.modelData?.signalStrength ?? 0)
                                active: knownItem.isConnected
                            }

                            Text {
                                Layout.fillWidth: true
                                text: knownItem.modelData?.name ?? ""
                                color: Theme.text
                                font {
                                    family: Theme.mainFont
                                    pixelSize: 13
                                }
                                elide: Text.ElideRight
                            }

                            IconImage {
                                visible: (knownItem.modelData?.security ?? 0) !== 0
                                Layout.preferredWidth: 14
                                Layout.preferredHeight: 14
                                source: Quickshell.iconPath("changes-prevent-symbolic")
                            }
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                color: Theme.border
                Layout.topMargin: 4
                Layout.bottomMargin: 4
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.leftMargin: 8
                Layout.rightMargin: 8
                Layout.topMargin: 2
                Layout.bottomMargin: 2

                Text {
                    text: "Other Networks"
                    color: Theme.textMuted
                    font {
                        family: Theme.mainFont
                        pixelSize: 12
                        weight: Font.DemiBold
                    }
                    Layout.fillWidth: true
                }

                Image {
                    id: refreshIcon
                    width: 14
                    height: 14
                    source: Quickshell.iconPath("view-refresh-symbolic")
                    sourceSize: Qt.size(width, height)
                    opacity: refreshMouse.containsMouse ? 1.0 : 0.6

                    RotationAnimation on rotation {
                        running: internal.device?.scannerEnabled ?? false
                        from: 0
                        to: 360
                        duration: 1000
                        loops: Animation.Infinite
                    }

                    MouseArea {
                        id: refreshMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (internal.device) {
                                internal.device.scannerEnabled = !internal.device.scannerEnabled;
                            }
                        }
                    }
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2
                visible: internal.hasOther

                Repeater {
                    model: internal.device?.networks ?? null

                    delegate: Squircle {
                        id: otherItem
                        required property var modelData
                        visible: !(otherItem.modelData?.known ?? true) && (otherItem.modelData?.name ?? "") !== ""
                        Layout.fillWidth: true
                        Layout.preferredHeight: visible ? 36 : 0
                        fillColor: otherArea.containsMouse ? Theme.surface : Theme.transparent
                        cornerRadius: 6

                        MouseArea {
                            id: otherArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            enabled: !(otherItem.modelData?.stateChanging ?? false)
                            onClicked: root._onNetworkClick(otherItem.modelData)
                        }

                        RowLayout {
                            anchors {
                                fill: parent
                                leftMargin: 8
                                rightMargin: 8
                            }
                            spacing: 12

                            IconCircle {
                                size: 24
                                source: root._getWifiIcon(otherItem.modelData?.signalStrength ?? 0)
                                active: false
                            }

                            Text {
                                Layout.fillWidth: true
                                text: otherItem.modelData?.name ?? ""
                                color: Theme.text
                                opacity: 0.8
                                font {
                                    family: Theme.mainFont
                                    pixelSize: 13
                                }
                                elide: Text.ElideRight
                            }

                            IconImage {
                                visible: (otherItem.modelData?.security ?? 0) !== 0
                                Layout.preferredWidth: 14
                                Layout.preferredHeight: 14
                                source: Quickshell.iconPath("changes-prevent-symbolic")
                            }
                        }
                    }
                }
            }
        }
    }

    WifiPasswordPrompt {
        id: pskPrompt
        property var network: null
        onSubmitted: text => {
            if (network)
                network.connectWithPsk(text);
        }
    }
}
