import QtQuick

Canvas {
    id: root

    enum Corner { TopLeft, TopRight, BottomRight, BottomLeft }

    property int corner: RoundCorner.TopLeft
    property real size: 12
    property color color: "black"

    implicitWidth: size
    implicitHeight: size

    onColorChanged: requestPaint()
    onSizeChanged: requestPaint()
    onCornerChanged: requestPaint()

    onPaint: {
        const ctx = getContext("2d");
        ctx.reset();
        ctx.fillStyle = color;
        ctx.beginPath();
        const s = size;
        switch (corner) {
        case RoundCorner.TopLeft:
            ctx.moveTo(0, 0);
            ctx.lineTo(s, 0);
            ctx.arc(s, s, s, -Math.PI / 2, Math.PI, true);
            break;
        case RoundCorner.TopRight:
            ctx.moveTo(s, 0);
            ctx.lineTo(s, s);
            ctx.arc(0, s, s, 0, -Math.PI / 2, true);
            break;
        case RoundCorner.BottomRight:
            ctx.moveTo(s, s);
            ctx.lineTo(0, s);
            ctx.arc(0, 0, s, Math.PI / 2, 0, true);
            break;
        case RoundCorner.BottomLeft:
            ctx.moveTo(0, s);
            ctx.lineTo(0, 0);
            ctx.arc(s, 0, s, Math.PI, Math.PI / 2, true);
            break;
        }
        ctx.closePath();
        ctx.fill();
    }
}
