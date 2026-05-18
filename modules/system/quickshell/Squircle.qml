import QtQuick

ShaderEffect {
    id: root

    property color fillColor: "transparent"
    property color strokeColor: "transparent"
    property real strokeWidth: 0
    property real cornerRadius: 12

    fragmentShader: "squircle.qsb"
}
