import QtQuick
import "."

Rectangle {
    id: root

    readonly property color accent: Theme.parchment

    implicitWidth: Theme.barWidth - Theme.barPadding * 2
    implicitHeight: layout.implicitHeight + Theme.barPadding * 2
    color: Theme.dusk
    radius: Theme.rounding

    Timer {
        id: tick
        property var now: new Date()
        interval: 10000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: now = new Date()
    }

    Column {
        id: layout
        anchors.centerIn: parent
        spacing: 4

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            text: Qt.formatDateTime(tick.now, "M\nd")
            color: root.accent
            font.pixelSize: 11
        }

        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width * 0.7
            height: 1
            color: root.accent
            opacity: 0.25
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            text: Qt.formatDateTime(tick.now, "hh\nmm")
            color: root.accent
            font.family: "monospace"
            font.pixelSize: 12
            font.bold: true
        }
    }
}
