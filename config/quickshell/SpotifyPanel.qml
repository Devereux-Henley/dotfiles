import QtQuick
import Quickshell
import "."

PanelWindow {
    id: root

    anchors {
        top: true
        left: true
        right: true
    }
    implicitHeight: spotify.expandedHeight
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore

    mask: Region {
        Region {
            x: root.width / 2 - spotify.implicitWidth / 2
            y: 0
            width: spotify.present ? spotify.implicitWidth : 0
            height: spotify.implicitHeight
        }
    }

    SpotifyWidget {
        id: spotify
        anchors.horizontalCenter: parent.horizontalCenter
        y: 0
    }
}
