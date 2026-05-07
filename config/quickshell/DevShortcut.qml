import QtQuick
import Quickshell.Io
import "."

Item {
    id: root

    property string icon: ""
    property string materialIcon: ""
    property string label: ""
    property string editor: ""
    property string shell: ""
    property string browser: ""
    property string all: ""

    property string editorIcon: ""
    property string shellIcon: ""
    property string browserIcon: ""
    property string allIcon: ""

    readonly property string workspaceRange: "[1,2,3,4,5,6,7]"

    implicitWidth: Theme.iconHitbox
    implicitHeight: Theme.iconHitbox

    AppLauncher {
        anchors.fill: parent
        iconName: root.icon
        materialIcon: root.materialIcon
        fallbackText: root.label
        onLaunch: root.openMenu()
    }

    function shquote(s) {
        return "'" + String(s || "").replace(/'/g, "'\\''") + "'";
    }

    function openMenu() {
        if (menu.running) return;

        const lines = [];
        if (root.editor)  lines.push("Editor\\0icon\\x1f"  + root.editorIcon);
        if (root.shell)   lines.push("Shell\\0icon\\x1f"   + root.shellIcon);
        if (root.browser) lines.push("Browser\\0icon\\x1f" + root.browserIcon);
        if (root.editor || root.shell || root.browser || root.all) {
            lines.push("All\\0icon\\x1f" + root.allIcon);
        }
        if (!lines.length) return;

        const stdin = lines.join("\\n");
        const prompt = (root.label || "Project").replace(/'/g, "'\\''");
        const jqPick =
            ". as $ws | " + root.workspaceRange + " | map(. as $id | {" +
            "id: $id, " +
            "windows: ((($ws | map(select(.id == $id)))[0]).windows // 0)" +
            "}) | min_by([.windows, .id]) | .id";

        const script = [
            "target=$(printf '%b' '" + stdin + "' | rofi -dmenu -i -show-icons -p '" + prompt + "')",
            "[ -z \"$target\" ] && exit 0",
            "ws=$(hyprctl workspaces -j | jq -r " + root.shquote(jqPick) + ")",
            "[ -z \"$ws\" ] && exit 0",
            "EDITOR_CMD="  + root.shquote(root.editor),
            "SHELL_CMD="   + root.shquote(root.shell),
            "BROWSER_CMD=" + root.shquote(root.browser),
            "ALL_CMD="     + root.shquote(root.all),
            "before=$(mktemp); after=$(mktemp)",
            "trap 'rm -f \"$before\" \"$after\"' EXIT",
            "launch_to_ws() {",
            "  hyprctl clients -j | jq -r '.[].address' | sort > \"$before\"",
            "  expected=0",
            "  for cmd in \"$@\"; do",
            "    if [ -n \"$cmd\" ]; then",
            "      hyprctl dispatch exec \"[workspace $ws silent] $cmd\" >/dev/null",
            "      expected=$((expected + 1))",
            "    fi",
            "  done",
            "  [ \"$expected\" -eq 0 ] && return 0",
            "  i=0",
            "  while [ \"$i\" -lt 60 ]; do",
            "    sleep 0.2",
            "    hyprctl clients -j | jq -r '.[].address' | sort > \"$after\"",
            "    new=$(comm -13 \"$before\" \"$after\")",
            "    if [ -n \"$new\" ]; then",
            "      count=$(printf '%s\\n' \"$new\" | grep -c '^0x' || true)",
            "      [ \"$count\" -ge \"$expected\" ] && break",
            "    fi",
            "    i=$((i + 1))",
            "  done",
            "  new=$(comm -13 \"$before\" \"$after\")",
            "  for addr in $new; do",
            "    [ -n \"$addr\" ] && hyprctl dispatch movetoworkspacesilent \"$ws,address:$addr\" >/dev/null",
            "  done",
            "}",
            "case \"$target\" in",
            "  Editor)  launch_to_ws \"$EDITOR_CMD\" ;;",
            "  Shell)   launch_to_ws \"$SHELL_CMD\" ;;",
            "  Browser) launch_to_ws \"$BROWSER_CMD\" ;;",
            "  All)",
            "    if [ -n \"$ALL_CMD\" ]; then launch_to_ws \"$ALL_CMD\";",
            "    else launch_to_ws \"$EDITOR_CMD\" \"$SHELL_CMD\" \"$BROWSER_CMD\";",
            "    fi ;;",
            "esac"
        ].join("\n");

        menu.command = ["sh", "-c", script];
        menu.running = true;
    }

    Process {
        id: menu
        command: ["true"]
    }
}
