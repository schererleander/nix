import QtQuick
import QtQuick.Controls

CheckBox {
    id: control
    
    contentItem: Text {
        text: control.text
        color: Theme.text
        font.family: Theme.mainFont
        font.pixelSize: 13
        verticalAlignment: Text.AlignVCenter
        leftPadding: control.indicator.width + control.spacing
    }
    
    indicator: Rectangle {
        implicitWidth: 14
        implicitHeight: 14
        x: control.leftPadding
        y: Math.round((control.height - height) / 2)
        radius: 3.5
        color: control.checked ? Theme.accent : Theme.surface
        border.color: control.checked ? Theme.accent : Theme.border
        border.width: 1

        Canvas {
            anchors.fill: parent
            visible: control.checked
            onPaint: {
                var ctx = getContext("2d");
                ctx.reset();
                ctx.lineWidth = 1.5;
                ctx.strokeStyle = "white";
                ctx.lineCap = "round";
                ctx.lineJoin = "round";
                ctx.beginPath();
                ctx.moveTo(3, 7);
                ctx.lineTo(6, 10);
                ctx.lineTo(11, 4);
                ctx.stroke();
            }
        }
    }
}
