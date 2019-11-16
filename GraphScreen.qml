import QtQuick 2.1
import qb.components 1.0
import BasicUIControls 1.0

import "dateHelpers.js" as DateHelpers

Screen {
	id: graphScreen
    screenTitle: "graph"

    onCustomButtonClicked: app.openScreen("config")

    function init() {
        bottomTabBar.addItem(qsTr("Hours"), "Hours");
		bottomTabBar.addItem(qsTr("Days"), "Days");
		bottomTabBar.addItem(qsTr("Weeks"), "Weeks");
		bottomTabBar.addItem(qsTr("Months"), "Months");
		bottomTabBar.addItem(qsTr("Years"), "Years");

        bottomTabBar.currentIndex = 0;
        topRightTabBarControlGroup.currentControlId = 0;
    }

	function update() {
		const options = {}
		options.startDate = dateSelector.periodStart
		options.endDate = dateSelector.periodEnd

		if(dateSelector.periodStart.getTime() == dateSelector.periodEnd.getTime()) {
			options.endDate = DateHelpers.addDay(options.endDate)
		}

		app.getData(
            "powerGraph",
            function(data) {
				if(!data.values) {
					return
				}
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

				if(startAvg < 0 || endAvg < 0) {
					return
				}

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
            },
			options
        )
	}

    onShown: {
        addCustomTopRightButton("Config")

		update()
    }

    ControlGroup {
		id: topRightTabBarControlGroup
        currentControlId: 0
		exclusive: true
		onCurrentControlIdChanged: {

        }
		onCurrentControlIdChangedByUser: {

        }
	}

	Flow {
		id: topRightTabBar
		anchors {
			right: graphRect.right
			top: parent.top
			topMargin: designElements.vMargin20
		}
		spacing: Math.round(4 * horizontalScaling)

		TopTabButton {
			id: currencyButton
			text: i18n.currency()
			controlGroup: topRightTabBarControlGroup
			leftClickMargin: 10
			kpiId: "Costs"
            visible: bottomTabBar.currentIndex != 0
		}

		TopTabButton {
			id: energyButton
            text: qsTr("Watt")
			controlGroup: topRightTabBarControlGroup
			kpiId: "Unit"
		}
	}

    Rectangle {
        
        id: graphRect

        anchors {
            top: topRightTabBar.bottom
			topMargin: colors.tabButtonUseExtension ? Math.round(4 * verticalScaling) : 0
			bottom: bottomTabBar.top
			bottomMargin: anchors.topMargin
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

    BottomTabBar {
		id: bottomTabBar
        currentIndex: 0
		anchors {
			left: graphRect.left
			bottom: parent.bottom
		}
        onCurrentControlIdChangedByUser: {

        }
		onCurrentIndexChanged: {
			
		}
	}

    Rectangle {
		height: dateSelector.height
		width: dateSelector.width
		x: dateSelector.x
		y: dateSelector.y
		color: colors.graphScreenBackground
		visible: dateSelector.visible
	}

    DateSelector {
		id: dateSelector
		anchors {
			right: graphRect.right
			top: graphRect.bottom
		}
		mode: {
			switch(bottomTabBar.currentIndex) {
				case 3:
					return DateSelectorComponent.MODE_YEAR
				case 2:
					return DateSelectorComponent.MODE_MONTH
				case 1:
					return DateSelectorComponent.MODE_WEEK
				default:
					return DateSelectorComponent.MODE_DAY
			}
		}
		periodStart: new Date()
        periodMaximum: new Date()
		onPeriodChanged: {
			graphScreen.update()
		}
		visible: bottomTabBar.currentIndex != 4
	}
        
}