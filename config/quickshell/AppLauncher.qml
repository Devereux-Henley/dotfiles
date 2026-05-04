import QtQuick
import Quickshell
import "."

Rectangle {
    id: root

    property string iconName
    property string fallbackText: ""
    signal launch()

    width: Theme.iconHitbox
    height: Theme.iconHitbox
    radius: Theme.rounding
    color: mouse.containsMouse ? Theme.dusk : "transparent"

    Behavior on color {
        ColorAnimation { duration: 120 }
    }

    Image {
        id: icon
        anchors.centerIn: parent
        width: Theme.iconSize
        height: Theme.iconSize
        sourceSize.width: Theme.iconSize
        sourceSize.height: Theme.iconSize
        smooth: true
        source: root.iconName.startsWith("/") || root.iconName.startsWith("file:")
                ? root.iconName
                : Quickshell.iconPath(root.iconName, "")
        visible: status === Image.Ready
    }

    Text {
        anchors.centerIn: parent
        visible: icon.status !== Image.Ready && root.fallbackText !== ""
        text: root.fallbackText
        color: Theme.parchment
        font.pixelSize: 16
        font.bold: true
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.launch()
    }
}
