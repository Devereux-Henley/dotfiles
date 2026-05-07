import QtQuick
import Quickshell
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

    readonly property string iconBase: Quickshell.env("HOME") + "/.local/share/dhenley-rice-icons"

    function openMenu() {
        if (menu.running) return;
        const rowsJq =
            "sort_by(.id) | .[] | " +
            "if (.id >= 1 and .id <= 9) then " +
                "\"(\\(.windows) windows)\\u0000icon\\u001f\\($base)/filter_\\(.id).svg\" " +
            "elif (.id >= 10) then " +
                "\"\\(.id)  (\\(.windows) windows)\\u0000icon\\u001f\\($base)/filter_9_plus.svg\" " +
            "elif (.name == \"special:music\") then " +
                "\"(\\(.windows) windows)\\u0000icon\\u001f\\($base)/library_music.svg\" " +
            "elif (.name == \"special:communication\") then " +
                "\"(\\(.windows) windows)\\u0000icon\\u001f\\($base)/chat.svg\" " +
            "else " +
                "\"\\(.name)  (\\(.windows) windows)\" " +
            "end";
        const script =
            "ws_json=$(mktemp); trap 'rm -f \"$ws_json\"' EXIT; " +
            "hyprctl workspaces -j > \"$ws_json\"; " +
            "names=$(jq -r 'sort_by(.id) | .[] | .name' \"$ws_json\"); " +
            "idx=$(jq -r --arg base '" + root.iconBase + "' '" + rowsJq + "' \"$ws_json\" | rofi -dmenu -i -show-icons -format 'd' -p 'Workspace'); " +
            "[ -z \"$idx\" ] && exit 0; " +
            "printf '%s\\n' \"$names\" | sed -n \"${idx}p\"";
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
