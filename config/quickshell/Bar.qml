import QtQuick
import QtQuick.Layouts
import "."

ColumnLayout {
    spacing: Theme.spacing

    Item { Layout.fillHeight: true }

    Clock {
        Layout.alignment: Qt.AlignHCenter
    }

    PowerButton {
        Layout.alignment: Qt.AlignHCenter
    }
}
