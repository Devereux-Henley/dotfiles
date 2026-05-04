import QtQuick
import Quickshell
import "."

PanelWindow {
    id: root

    required property string edge
    property int thickness: Theme.wrapThickness

    anchors {
        top: root.edge !== "bottom"
        bottom: root.edge !== "top"
        left: root.edge !== "right"
        right: root.edge !== "left"
    }

    implicitWidth: (root.edge === "left" || root.edge === "right") ? 1 : 0
    implicitHeight: (root.edge === "top" || root.edge === "bottom") ? 1 : 0

    color: "transparent"
    exclusiveZone: root.thickness
}
