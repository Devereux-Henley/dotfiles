import QtQuick
import Quickshell.Hyprland
import "."

Rectangle {
    id: root

    width: Theme.iconHitbox
    height: Theme.iconHitbox
    radius: Theme.rounding
    color: mouse.containsMouse ? Theme.flame : "transparent"

    Behavior on color {
        ColorAnimation { duration: 120 }
    }

    Text {
        anchors.centerIn: parent
        text: "⏻"
        color: mouse.containsMouse ? Theme.parchment : Theme.flame
        font.pixelSize: 20
        font.bold: true
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: Hyprland.dispatch(
            "exec sh -c 'command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit'"
        )
    }
}
