import QtQuick
import QtQuick.Layouts
import "."

ColumnLayout {
    spacing: Theme.spacing

    WorkspaceSwitcher {
        Layout.alignment: Qt.AlignHCenter
    }

    DevShortcutsBar {
        Layout.alignment: Qt.AlignHCenter
    }

    Item { Layout.fillHeight: true }

    GameModeButton {
        Layout.alignment: Qt.AlignHCenter
    }

    Clock {
        Layout.alignment: Qt.AlignHCenter
    }

    PowerButton {
        Layout.alignment: Qt.AlignHCenter
    }
}
