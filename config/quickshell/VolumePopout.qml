import QtQuick
import QtQuick.Templates as T
import Quickshell.Io
import "."

Item {
    id: root

    property bool open: false
    property real volume: 0

    readonly property bool hovered: hover.hovered

    implicitWidth: 44 + Theme.casingPadding * 2
    implicitHeight: 220 + Theme.casingPadding * 2

    HoverHandler {
        id: hover
    }

    Rectangle {
        anchors.fill: parent
        color: Theme.twilight
        topLeftRadius: Theme.casingPadding * 2
        bottomLeftRadius: Theme.casingPadding * 2
        topRightRadius: 0
        bottomRightRadius: 0
    }

    T.Slider {
        id: slider
        anchors.fill: parent
        anchors.margins: Theme.casingPadding
        orientation: Qt.Vertical
        from: 0
        to: 1
        stepSize: 0.01
        value: root.volume

        background: Rectangle {
            anchors.fill: parent
            color: Theme.dusk
            radius: width / 2

            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                y: slider.handle.y
                height: parent.height - y
                color: Theme.ember
                radius: parent.radius
            }
        }

        handle: Rectangle {
            y: slider.visualPosition * (slider.availableHeight - height)
            implicitWidth: slider.width
            implicitHeight: slider.width
            color: Theme.parchment
            radius: width / 2
        }

        onMoved: {
            root.volume = value;
            setVol.command = ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", value.toFixed(2)];
            setVol.running = true;
        }
    }

    Process {
        id: getVol
        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
        stdout: SplitParser {
            onRead: data => {
                const m = data.match(/Volume:\s*([\d.]+)/);
                if (m) root.volume = parseFloat(m[1]);
            }
        }
    }

    Process {
        id: setVol
    }

    Timer {
        interval: 500
        running: root.open && !slider.pressed
        repeat: true
        triggeredOnStart: true
        onTriggered: getVol.running = true
    }
}
