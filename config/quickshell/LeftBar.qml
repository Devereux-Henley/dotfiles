import QtQuick
import Quickshell
import "."

PanelWindow {
    id: root

    readonly property real verticalInset: 0.075

    anchors {
        top: true
        bottom: true
        left: true
    }
    implicitWidth: Theme.barWidth
    color: "transparent"
    exclusiveZone: implicitWidth

    Rectangle {
        id: barBg
        x: 0
        y: parent.height * root.verticalInset
        width: Theme.barWidth
        height: parent.height * (1 - 2 * root.verticalInset)
        color: Theme.wrapColor
        topLeftRadius: 0
        bottomLeftRadius: 0
        topRightRadius: Theme.rounding
        bottomRightRadius: Theme.rounding
    }

    Bar {
        anchors.fill: barBg
        anchors.topMargin: Theme.barPadding
        anchors.bottomMargin: Theme.barPadding
    }
}
