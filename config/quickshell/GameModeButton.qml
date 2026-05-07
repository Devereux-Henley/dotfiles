import QtQuick
import Quickshell.Io
import "."

// Mirrors caelestia's services/GameMode.qml strategy: when enabled,
// hyprctl --batch overrides animations/blur/shadow/gaps/rounding and
// flips allow_tearing; when disabled, hyprctl reload restores config.
// State on startup is read from hyprctl (animations:enabled == 0
// implies game mode is currently on).
Item {
    id: root

    property bool enabled: false

    implicitWidth: Theme.iconHitbox
    implicitHeight: Theme.iconHitbox

    AppLauncher {
        anchors.fill: parent
        materialIcon: "gamepad"
        iconColor: root.enabled ? Theme.ember : Theme.parchment
        onLaunch: root.toggle()
    }

    function toggle() {
        if (toggleProc.running) return;
        if (root.enabled) {
            toggleProc.command = ["hyprctl", "reload"];
        } else {
            const batch = [
                "keyword animations:enabled 0",
                "keyword decoration:shadow:enabled 0",
                "keyword decoration:blur:enabled 0",
                "keyword general:gaps_in 0",
                "keyword general:gaps_out 0",
                "keyword general:border_size 1",
                "keyword decoration:rounding 0",
                "keyword general:allow_tearing 1"
            ].join("; ");
            toggleProc.command = ["hyprctl", "--batch", batch];
        }
        root.enabled = !root.enabled;
        toggleProc.running = true;
    }

    Process {
        id: toggleProc
        command: ["true"]
    }

    Process {
        id: stateQuery
        running: true
        command: ["sh", "-c", "hyprctl getoption animations:enabled -j | jq -r .int"]
        stdout: SplitParser {
            onRead: data => {
                root.enabled = data.trim() === "0";
            }
        }
    }
}
