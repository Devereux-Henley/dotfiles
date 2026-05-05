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
        Region { x: 0; y: 0; width: root.width; height: Theme.wrapThicknessTopBottom }
        Region { x: 0; y: root.height - Theme.wrapThicknessTopBottom; width: root.width; height: Theme.wrapThicknessTopBottom }
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
        color: Theme.wrapColor
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: Theme.wrapThicknessTopBottom
    }
    Rectangle {
        color: Theme.wrapColor
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: Theme.wrapThicknessTopBottom
    }
    Rectangle {
        color: Theme.wrapColor
        anchors.top: parent.top
        anchors.topMargin: Theme.wrapThicknessTopBottom
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Theme.wrapThicknessTopBottom
        anchors.left: parent.left
        width: Theme.barWidth
    }
    Rectangle {
        id: rightStrip
        color: Theme.wrapColor
        anchors.top: parent.top
        anchors.topMargin: Theme.wrapThicknessTopBottom
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Theme.wrapThicknessTopBottom
        anchors.right: parent.right
        width: Theme.wrapThickness

        HoverHandler {
            id: stripHover
        }
    }

    RoundCorner {
        corner: RoundCorner.TopLeft
        size: Theme.rounding
        color: Theme.wrapColor
        x: Theme.barWidth
        y: Theme.wrapThicknessTopBottom
    }
    RoundCorner {
        corner: RoundCorner.TopRight
        size: Theme.rounding
        color: Theme.wrapColor
        x: root.width - Theme.wrapThickness - width
        y: Theme.wrapThicknessTopBottom
    }
    RoundCorner {
        corner: RoundCorner.BottomLeft
        size: Theme.rounding
        color: Theme.wrapColor
        x: Theme.barWidth
        y: root.height - Theme.wrapThicknessTopBottom - height
    }
    RoundCorner {
        corner: RoundCorner.BottomRight
        size: Theme.rounding
        color: Theme.wrapColor
        x: root.width - Theme.wrapThickness - width
        y: root.height - Theme.wrapThicknessTopBottom - height
    }

    Bar {
        anchors.left: parent.left
        width: Theme.barWidth
        anchors.top: parent.top
        anchors.topMargin: Theme.wrapThicknessTopBottom + Theme.barPadding
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Theme.wrapThicknessTopBottom - Theme.barPadding / 2
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
