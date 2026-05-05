import QtQuick
import Quickshell
import "."

Variants {
    model: Quickshell.screens.length > 0 ? [Quickshell.screens[0]] : []

    Scope {
        id: scope
        required property var modelData

        LeftBar { screen: scope.modelData }
        SpotifyPanel { screen: scope.modelData }
        VolumePanel { screen: scope.modelData }
    }
}
