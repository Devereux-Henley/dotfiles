import QtQuick
import Quickshell
import "."

Variants {
    model: Quickshell.screens

    Scope {
        id: scope
        required property var modelData

        ContentWindow { screen: scope.modelData }
        EdgeExclusion { screen: scope.modelData; edge: "top" }
        EdgeExclusion { screen: scope.modelData; edge: "right" }
        EdgeExclusion { screen: scope.modelData; edge: "bottom" }
        EdgeExclusion { screen: scope.modelData; edge: "left"; thickness: Theme.barWidth }
    }
}
