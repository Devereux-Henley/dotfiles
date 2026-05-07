import QtQuick
import Quickshell.Io
import "."

Column {
    id: root

    spacing: Theme.spacing

    property var config: ({ icons: {}, shortcuts: [] })

    Process {
        id: loader
        running: true
        command: ["sh", "-c", "cat ~/.config/quickshell/dev-shortcuts.json 2>/dev/null | tr -d '\\n'; echo"]
        stdout: SplitParser {
            onRead: data => {
                const body = data.trim();
                if (!body) return;
                try {
                    const parsed = JSON.parse(body);
                    root.config = {
                        icons: parsed.icons || {},
                        shortcuts: parsed.shortcuts || []
                    };
                } catch (e) {
                    console.warn("DevShortcuts: parse error:", e);
                }
            }
        }
    }

    Repeater {
        model: root.config.shortcuts
        delegate: DevShortcut {
            icon: modelData.icon || ""
            label: modelData.label || ""
            editor: modelData.editor || ""
            shell: modelData.shell || ""
            browser: modelData.browser || ""
            all: modelData.all || ""
            editorIcon: root.config.icons.editor || ""
            shellIcon: root.config.icons.shell || ""
            browserIcon: root.config.icons.browser || ""
            allIcon: root.config.icons.all || ""
        }
    }
}
