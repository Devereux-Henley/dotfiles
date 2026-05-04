pragma Singleton
import QtQuick

QtObject {
    // Grothmar Valley — keep in sync with config/hypr/palette.conf
    readonly property color twilight:  "#2A2440"
    readonly property color dusk:      "#3D3658"
    readonly property color parchment: "#F5DEB3"
    readonly property color mist:      "#C9B8D8"
    readonly property color ember:     "#E8743C"
    readonly property color bloom:     "#C26285"
    readonly property color amber:     "#E8B547"
    readonly property color meadow:    "#7BA859"
    readonly property color river:     "#5FA89F"
    readonly property color sky:       "#6B8FB8"
    readonly property color flame:     "#D04738"

    readonly property int barWidth:        48
    readonly property int wrapThickness:   12
    readonly property int barPadding:      8
    readonly property int casingPadding:   14
    readonly property int iconSize:        28
    readonly property int iconHitbox:      36
    readonly property int borderThickness: 2
    readonly property int spacing:         10
    readonly property int rounding:        6
}
