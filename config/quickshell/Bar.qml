import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import "."

ColumnLayout {
    spacing: Theme.spacing

    AppLauncher {
        Layout.alignment: Qt.AlignHCenter
        iconName: "com.spotify.Client"
        fallbackText: "S"
        onLaunch: Hyprland.dispatch("exec flatpak run com.spotify.Client")
    }

    AppLauncher {
        Layout.alignment: Qt.AlignHCenter
        iconName: "/opt/Discord/discord.png"
        fallbackText: "D"
        onLaunch: Hyprland.dispatch("exec discord")
    }

    Item { Layout.fillHeight: true }

    Clock {
        Layout.alignment: Qt.AlignHCenter
    }

    PowerButton {
        Layout.alignment: Qt.AlignHCenter
    }
}
