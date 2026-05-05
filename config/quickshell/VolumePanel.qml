import QtQuick
import Quickshell
import "."

PanelWindow {
    id: root

    anchors {
        top: true
        right: true
        bottom: true
    }
    implicitWidth: popout.implicitWidth
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore

    readonly property int triggerWidth: 6
    readonly property int triggerVerticalPadding: 24
    readonly property bool open: triggerHover.hovered || popout.hovered

    HoverHandler { id: triggerHover }

    mask: Region {
        Region {
            x: root.width - root.triggerWidth
            y: (root.height - popout.implicitHeight) / 2 - root.triggerVerticalPadding
            width: root.triggerWidth
            height: popout.implicitHeight + root.triggerVerticalPadding * 2
        }
        Region {
            x: 0
            y: (root.height - popout.implicitHeight) / 2
            width: root.open ? popout.implicitWidth : 0
            height: popout.implicitHeight
        }
    }

    VolumePopout {
        id: popout
        open: root.open
        x: root.open ? 0 : root.width
        y: (parent.height - height) / 2
        Behavior on x {
            NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
        }
    }
}
