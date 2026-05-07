import QtQuick
import Quickshell.Io
import Quickshell.Hyprland
import "."

Item {
    id: root

    implicitWidth: Theme.iconHitbox
    implicitHeight: Theme.iconHitbox

    AppLauncher {
        anchors.fill: parent
        materialIcon: "apps"
        iconColor: Theme.parchment
        onLaunch: root.openMenu()
    }

    function openMenu() {
        if (menu.running) return;
        const script =
            "choice=$(hyprctl workspaces -j | jq -r 'sort_by(.id) | .[] | \"\\(.name)  (\\(.windows) windows)\"' | rofi -dmenu -i -p 'Workspace'); " +
            "[ -z \"$choice\" ] && exit 0; " +
            "printf '%s\\n' \"${choice%  (*}\"";
        menu.command = ["sh", "-c", script];
        menu.running = true;
    }

    Process {
        id: menu
        command: ["true"]
        stdout: SplitParser {
            onRead: data => {
                const ws = data.trim();
                if (!ws) return;
                const arg = /^[0-9]+$/.test(ws) ? ws : "name:" + ws;
                Hyprland.dispatch("workspace " + arg);
            }
        }
    }
}
