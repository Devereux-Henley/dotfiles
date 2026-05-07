import QtQuick
import QtQuick.Effects
import Quickshell
import "."

Rectangle {
    id: root

    property string iconName
    property string materialIcon: ""
    property color iconColor: Theme.parchment
    property string fallbackText: ""
    property color tintColor: "transparent"
    property color tintSourceColor: "#808080"
    signal launch()

    width: Theme.iconHitbox
    height: Theme.iconHitbox
    radius: Theme.rounding
    color: mouse.containsMouse ? Theme.dusk : "transparent"

    Behavior on color {
        ColorAnimation { duration: 120 }
    }

    MaterialIcon {
        anchors.centerIn: parent
        visible: root.materialIcon !== ""
        text: root.materialIcon
        color: root.iconColor
    }

    Image {
        id: icon
        anchors.centerIn: parent
        width: Theme.iconSize
        height: Theme.iconSize
        sourceSize.width: Theme.iconSize
        sourceSize.height: Theme.iconSize
        smooth: true
        source: /^(\/|\w+:)/.test(root.iconName)
                ? root.iconName
                : Quickshell.iconPath(root.iconName, "")
        visible: root.materialIcon === "" && status === Image.Ready

        layer.enabled: root.tintColor.a > 0
        layer.effect: MultiEffect {
            colorization: 1.0
            brightness: 1.0 - root.tintSourceColor.hslLightness
            colorizationColor: root.tintColor
        }
    }

    Text {
        anchors.centerIn: parent
        visible: root.materialIcon === "" && icon.status !== Image.Ready && root.fallbackText !== ""
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
