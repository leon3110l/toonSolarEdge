import QtQuick 2.1
import qb.components 1.0

Screen {

    screenTitle: "graph"

    onCustomButtonClicked: app.openScreen("config")

    onShown: {
        addCustomTopRightButton("Config")

        app.getData(
            "powerGraph",
            function(data) {
                const dataPoints = data.values.map(function(x) { return x.value })
                areaGraph.graphValues = dataPoints

                var maxValue = Math.max.apply(null, dataPoints)
                
                var scale = 100
                if(maxValue < 500) {
                    scale = 50
                } else if(maxValue < 250) {
                    scale = 25;
                }

                areaGraph.maxValue = Math.ceil(maxValue/scale) * scale

            }
        )
    }

    Rectangle {
        
        id: graphRect

        anchors {
            top: parent.top
			topMargin: 3
			bottom: parent.bottom
			bottomMargin: 3
			left: parent.left
			right: parent.right
			leftMargin: Math.round(16 * horizontalScaling)
			rightMargin: anchors.leftMargin
        }
        color: colors.graphScreenBackground

        AreaGraph {
            id: areaGraph

            width: graphRect.width
			height: graphRect.height

            anchors {
                top: graphRect.top
                left: graphRect.left
            }

            graphColor: "#f00"
            showNaN: true
            warningIconSource: "qrc:/images/bad.svg"
			warningIconVisible: false

            avgLineVisible: true
            maxValue: 250
        }
    }

        
}