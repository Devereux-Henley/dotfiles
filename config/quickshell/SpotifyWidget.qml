import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import Quickshell.Io
import "."

Item {
    id: root

    property string status: ""
    property string trackTitle: ""
    property string artist: ""
    property string artUrl: ""
    property real position: 0
    property real length: 0
    property bool seeking: false

    readonly property bool active: status === "Playing" || status === "Paused"
    readonly property bool playing: status === "Playing"
    readonly property bool present: status !== ""
    readonly property bool hovered: hover.hovered
    readonly property bool expanded: hover.hovered || seeking

    readonly property int collapsedHeight: 36
    readonly property int expandedHeight: 86

    implicitWidth: 400
    implicitHeight: present ? (expanded ? expandedHeight : collapsedHeight) : 0

    visible: present
    clip: true

    Behavior on implicitHeight {
        NumberAnimation { duration: 220; easing.type: Easing.OutCubic }
    }

    HoverHandler { id: hover }

    Rectangle {
        anchors.fill: parent
        color: Theme.wrapColor
        topLeftRadius: 0
        topRightRadius: 0
        bottomLeftRadius: Theme.rounding
        bottomRightRadius: Theme.rounding
    }

    RowLayout {
        id: controlsRow
        anchors.top: parent.top
        anchors.topMargin: 8
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: Theme.casingPadding
        anchors.rightMargin: Theme.casingPadding
        spacing: 5

        Rectangle {
            implicitWidth: 18
            implicitHeight: 18
            radius: width / 2
            color: prevMa.containsMouse ? Theme.dusk : "transparent"
            Behavior on color { ColorAnimation { duration: 120 } }
            Text {
                anchors.centerIn: parent
                text: "⏮"
                color: Theme.parchment
                font.pixelSize: 10
            }
            MouseArea {
                id: prevMa
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: ctl.run(["previous"])
            }
        }

        Rectangle {
            implicitWidth: 22
            implicitHeight: 22
            radius: width / 2
            color: playMa.containsMouse ? Theme.ember : Theme.dusk
            Behavior on color { ColorAnimation { duration: 120 } }
            Text {
                anchors.centerIn: parent
                text: root.playing ? "⏸" : "▶"
                color: Theme.parchment
                font.pixelSize: 11
            }
            MouseArea {
                id: playMa
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: ctl.run(["play-pause"])
            }
        }

        Rectangle {
            implicitWidth: 18
            implicitHeight: 18
            radius: width / 2
            color: nextMa.containsMouse ? Theme.dusk : "transparent"
            Behavior on color { ColorAnimation { duration: 120 } }
            Text {
                anchors.centerIn: parent
                text: "⏭"
                color: Theme.parchment
                font.pixelSize: 10
            }
            MouseArea {
                id: nextMa
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: ctl.run(["next"])
            }
        }

        Text {
            color: Theme.mist
            font.family: "monospace"
            font.pixelSize: 8
            text: root.formatTime(root.position)
        }

        T.Slider {
            id: slider
            Layout.fillWidth: true
            Layout.preferredHeight: 14
            from: 0
            to: Math.max(root.length, 1)
            value: root.position
            enabled: root.active && root.length > 0

            background: Rectangle {
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width
                height: 4
                color: Theme.dusk
                radius: 2
                Rectangle {
                    anchors.left: parent.left
                    width: parent.width * (slider.to > 0 ? slider.value / slider.to : 0)
                    height: parent.height
                    color: Theme.ember
                    radius: parent.radius
                }
            }

            handle: Rectangle {
                x: slider.visualPosition * (slider.availableWidth - width)
                y: (slider.availableHeight - height) / 2
                implicitWidth: 10
                implicitHeight: 10
                radius: width / 2
                color: Theme.parchment
            }

            onMoved: root.position = value
            onPressedChanged: {
                if (pressed) {
                    root.seeking = true;
                } else {
                    root.seeking = false;
                    ctl.run(["position", value.toFixed(2)]);
                }
            }
        }

        Text {
            color: Theme.mist
            font.family: "monospace"
            font.pixelSize: 8
            text: root.formatTime(root.length)
        }
    }

    Rectangle {
        id: artFrame
        anchors.top: controlsRow.bottom
        anchors.topMargin: 8
        anchors.left: parent.left
        anchors.leftMargin: Theme.casingPadding
        width: 40
        height: 40
        color: Theme.dusk
        opacity: root.expanded ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 160 } }

        Image {
            anchors.fill: parent
            source: root.artUrl
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
            cache: true
            visible: status === Image.Ready
        }
    }

    Column {
        anchors.left: artFrame.right
        anchors.leftMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: Theme.casingPadding
        anchors.verticalCenter: artFrame.verticalCenter
        spacing: 2
        opacity: root.expanded ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 160 } }

        Text {
            width: parent.width
            elide: Text.ElideRight
            color: Theme.parchment
            font.pixelSize: 12
            text: root.trackTitle || "Untitled"
        }

        Text {
            width: parent.width
            elide: Text.ElideRight
            color: Theme.mist
            font.pixelSize: 10
            text: root.artist || ""
        }
    }

    function formatTime(secs) {
        if (!secs || secs < 0) return "0:00";
        const m = Math.floor(secs / 60);
        const s = Math.floor(secs % 60);
        return m + ":" + (s < 10 ? "0" + s : s);
    }

    Process {
        id: ctl
        function run(extra) {
            command = ["playerctl", "--player=spotify"].concat(extra);
            running = true;
        }
    }

    Process {
        id: poll
        command: ["playerctl", "--player=spotify", "metadata", "--format",
                  "{{status}}|{{title}}|{{artist}}|{{position}}|{{mpris:length}}|{{mpris:artUrl}}"]
        stdout: SplitParser {
            onRead: data => {
                const parts = data.split("|");
                if (parts.length < 6) return;
                root.status = parts[0] || "";
                root.trackTitle = parts[1] || "";
                root.artist = parts[2] || "";
                const pos = parseFloat(parts[3]);
                const len = parseFloat(parts[4]);
                if (!root.seeking && !isNaN(pos)) root.position = pos / 1e6;
                if (!isNaN(len)) root.length = len / 1e6;
                root.artUrl = parts[5] || "";
            }
        }
        onExited: (exitCode, exitStatus) => {
            if (exitCode !== 0) {
                root.status = "";
                root.trackTitle = "";
                root.artist = "";
                root.artUrl = "";
                root.position = 0;
                root.length = 0;
            }
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: poll.running = true
    }

    Timer {
        interval: 250
        running: root.playing && !root.seeking && root.length > 0
        repeat: true
        onTriggered: {
            const next = root.position + 0.25;
            if (next < root.length) root.position = next;
        }
    }
}
