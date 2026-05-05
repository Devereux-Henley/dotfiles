import QtQuick
import Quickshell.Hyprland
import "."

Rectangle {
    id: root

    width: Theme.iconHitbox
    height: Theme.iconHitbox
    radius: width / 2
    color: mouse.containsMouse ? Theme.flame : Theme.dusk
    border.color: Theme.mist
    border.width: Theme.borderThickness

    Behavior on color {
        ColorAnimation { duration: 120 }
    }

    Text {
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: -1
        anchors.verticalCenterOffset: -1
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
