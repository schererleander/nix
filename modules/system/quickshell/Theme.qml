import QtQuick

pragma Singleton

QtObject {
    // Basics
    readonly property color bg: "#33000000" // More translucent for macOS 18 style
    readonly property color barBg: "#66000000"
    readonly property color surface: "#4DFFFFFF" // Semi-transparent white/gray
    readonly property color surfaceHover: "#66FFFFFF"
    readonly property color surfaceLighter: "#80FFFFFF"
    readonly property color border: "#1AFFFFFF"
    
    // Accents
    readonly property color accent: "#007AFF" // macOS Blue
    readonly property color accentHover: "#0066CC"
    readonly property color destructive: "#FF3B30"
    readonly property color focus: "#007AFF"
    
    // Text
    readonly property color text: "#FFFFFF"
    readonly property color textDim: "#EBEBEB"
    readonly property color textMuted: "#C6C6C6"
    readonly property color textDisabled: "#999999"
    readonly property color textPlaceholder: "#808080"
    readonly property color textLight: "#FFFFFF"
    
    // Icons
    readonly property color iconDefault: "#FFFFFF"
    readonly property color iconActive: "#007AFF"
    
    // Components
    readonly property color sliderTrack: "#33FFFFFF"
    readonly property color sliderHandle: "#FFFFFF"
    readonly property color sliderOutline: "#1A000000"
    
    // Transparency Helpers
    readonly property color scrim: "#80000000"
    readonly property color transparent: "transparent"

    // Layout
    readonly property int barHeight: 32 // Slightly taller for macOS look
    readonly property int popupGap: 8

    // Fonts
    readonly property string mainFont: "Inter"
    readonly property string monoFont: "JetBrains Mono"
}
