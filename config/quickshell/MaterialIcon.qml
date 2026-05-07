import QtQuick
import "."

Text {
    property real fill: 0
    property int grade: 0
    property int weight: 400

    font.family: "Material Symbols Rounded"
    font.pixelSize: Theme.iconSize
    color: Theme.parchment

    font.variableAxes: ({
        FILL: fill.toFixed(1),
        GRAD: grade,
        opsz: font.pixelSize,
        wght: weight
    })

    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
}
