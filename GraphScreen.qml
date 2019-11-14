import QtQuick 2.1
import qb.components 1.0
import BasicUIControls 1.0


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


                // avg data
                var startAvg = dataPoints.findIndex(function(x) {
                    return x > 0
                }) - 2
                var endAvg = dataPoints.length - dataPoints.reverse().findIndex(function(x) {
                    return x > 0
                }) - 2
                // -2 because data was two off, too lazy to find out why

                var avgDataPoints = dataPoints.slice(startAvg, endAvg)

                areaGraph.avgValue = avgDataPoints.reduce(function(a, b) { return a + b }) / avgDataPoints.length

                var startPos = areaGraph.getValuePos(startAvg + 1, areaGraph.graphValues)
                avgDotStart.anchors.topMargin = startPos.y - (avgDotStart.height / 2)
                avgDotStart.anchors.leftMargin = startPos.x - (avgDotStart.width / 2)

                var endPos = areaGraph.getValuePos(endAvg + 2, areaGraph.graphValues)
                avgDotEnd.anchors.topMargin = endPos.y - (avgDotEnd.height / 2)
                avgDotEnd.anchors.leftMargin = endPos.x - (avgDotEnd.width / 2)

                areaPopupTxt.text = qsTr("%1 Watt").arg(areaGraph.avgValue)
                areaPopout.anchors.topMargin = areaGraph.getValuePos(0, [areaGraph.avgValue, 0]).y - areaPopout.height - (areaPopout.borderWidth / 2)
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

            avgLineVisible: false
            avgValue: 0

            maxValue: 250
            visible: true

            onGraphClicked: toggleAvg()

            function toggleAvg() {
                avgDotStart.visible = !avgDotStart.visible;
                avgDotEnd.visible = !avgDotEnd.visible;
                avgLineVisible = !avgLineVisible;
                areaPopout.visible = !areaPopout.visible;
            }

            Rectangle {
				id: avgDotStart
				width: Math.round(8 * horizontalScaling)
				height: width
				radius: width / 2
				color: "#252525"
				visible: false
				anchors {
					top: parent.top
					left: parent.left
					leftMargin: 0
                    topMargin: 0
				}
			}
            Rectangle {
				id: avgDotEnd
				width: Math.round(8 * horizontalScaling)
				height: width
				radius: width / 2
				color: "#252525"
				visible: false
				anchors {
					top: parent.top
					left: parent.left
					leftMargin: 100
                    topMargin: 0
				}
			}

            StyledRectangle {
				id: areaPopout
				color: colors.white
				visible: false
				width: 15 + areaPopupTxt.width + 15 + horArrowSize
				height: 44 + verArrowSize
				anchors {
					top: parent.top
                    right: parent.right
                    topMargin: 50
                    rightMargin: 50
				}
				borderColor: colors._bg
				borderWidth: 2
				borderStyle: Qt.SolidLine
				radius: designElements.radius

				bottomLeftArrowVisible: true
				bottomRightArrowVisible: !bottomLeftArrowVisible
				horArrowSize: 4
				verArrowSize: 4

				Text {
					id: areaPopupTxt
					text: qsTr("%1 Watt").arg(areaGraph.avgValue)
					anchors {
						left: parent.left
						leftMargin: areaPopout.bottomLeftArrowVisible ? areaPopout.horArrowSize + 15 : 15
						verticalCenter: parent.top
						verticalCenterOffset: (areaPopout.height - areaPopout.verArrowSize) / 2
					}
					font {
						family: qfont.semiBold.name
						pixelSize: qfont.bodyText
					}
					color: popupDot.color
				}
			}
        }

        // BarGraph {
		// 	id: barGraph
		// 	width: parent.width
		// 	height: parent.height

		// 	dstEnd: graphRect.dstEnd
		// 	dstStart: graphRect.dstStart
		// 	dstHourChange: graphRect.dstHourChange

		// 	anchors {
		// 		horizontalCenter: parent.horizontalCenter
		// 		verticalCenter:  parent.verticalCenter
		// 	}
		// 	hourAxisVisible: bottomTabBar.currentIndex === 0
		// }
    }

        
}