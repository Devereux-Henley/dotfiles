import QtQuick
import Quickshell
import "."

PanelWindow {
    id: root

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    mask: Region {
        Region { x: 0; y: 0; width: root.width; height: Theme.wrapThickness }
        Region { x: 0; y: root.height - Theme.wrapThickness; width: root.width; height: Theme.wrapThickness }
        Region { x: 0; y: 0; width: Theme.barWidth; height: root.height }
        Region { x: root.width - Theme.wrapThickness; y: 0; width: Theme.wrapThickness; height: root.height }
        Region {
            x: volumePopout.x
            y: volumePopout.y
            width: volumePopout.width
            height: volumePopout.height
        }
    }

    Rectangle {
        color: Theme.twilight
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: Theme.wrapThickness
    }
    Rectangle {
        color: Theme.twilight
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: Theme.wrapThickness
    }
    Rectangle {
        color: Theme.twilight
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width: Theme.barWidth
    }
    Rectangle {
        id: rightStrip
        color: Theme.twilight
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        width: Theme.wrapThickness

        HoverHandler {
            id: stripHover
        }
    }

    RoundCorner {
        corner: RoundCorner.TopLeft
        size: Theme.rounding
        color: Theme.twilight
        x: Theme.barWidth
        y: Theme.wrapThickness
    }
    RoundCorner {
        corner: RoundCorner.TopRight
        size: Theme.rounding
        color: Theme.twilight
        x: root.width - Theme.wrapThickness - width
        y: Theme.wrapThickness
    }
    RoundCorner {
        corner: RoundCorner.BottomLeft
        size: Theme.rounding
        color: Theme.twilight
        x: Theme.barWidth
        y: root.height - Theme.wrapThickness - height
    }
    RoundCorner {
        corner: RoundCorner.BottomRight
        size: Theme.rounding
        color: Theme.twilight
        x: root.width - Theme.wrapThickness - width
        y: root.height - Theme.wrapThickness - height
    }

    Bar {
        anchors.left: parent.left
        width: Theme.barWidth
        anchors.top: parent.top
        anchors.topMargin: Theme.wrapThickness + Theme.barPadding
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Theme.wrapThickness + Theme.barPadding
    }

    VolumePopout {
        id: volumePopout
        open: stripHover.hovered || hovered
        y: parent.height / 2 - height / 2
        x: open
            ? parent.width - Theme.wrapThickness - width
            : parent.width
        Behavior on x {
            NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
        }
    }
}
