import QtQuick 2.1
import qb.components 1.0

Screen {

    screenTitle: "overview"

    onCustomButtonClicked: app.openScreen("config")

    onShown: {
        addCustomTopRightButton("Config")

        app.getData(
            'overview',
            function(overview) {
                lifetimeEnergy.text = (overview.lifeTimeData.energy / 1000).toFixed(1) + " kWh"
                lastYearEnergy.text = (overview.lastYearData.energy / 1000).toFixed(1) + " kWh"
                lastMonthEnergy.text = (overview.lastMonthData.energy / 1000).toFixed(1) + " kWh"
                lastDayEnergy.text = (overview.lastDayData.energy / 1000).toFixed(1) + " kWh"
                revenue.text = "€ " + overview.lifeTimeData.revenue.toFixed(2)
                currentPower.text = overview.currentPower.power + " W"
            }
        )
    }

    Column {
        spacing: 5
        anchors.centerIn: parent

        Row {
            spacing: 20
            Text {
                text: "Life time"
                font {
                    pointSize: 18
                    family: qfont.bold.name
                }
            }
        }
        Row {
            spacing: 20
            Text {
                text: "Energy"
                font {
                    pointSize: 16
                    family: qfont.semiBold.name
                }
            }
            Text {
                id: lifetimeEnergy
                text: "- kWh"
                font {
                    pointSize: 16
                    family: qfont.regular.name
                }
            }
        }
        Row {
            spacing: 20
            Text {
                text: "Revenue"
                font {
                    pointSize: 16
                    family: qfont.semiBold.name
                }
            }
            Text {
                id: revenue
                text: "€ -"
                font {
                    pointSize: 16
                    family: qfont.regular.name
                }
            }
        }

        Row {
            spacing: 20
            Text {
                text: "Last year"
                font {
                    pointSize: 18
                    family: qfont.bold.name
                }
            }
        }
        Row {
            spacing: 20
            Text {
                text: "Energy"
                font {
                    pointSize: 16
                    family: qfont.semiBold.name
                }
            }
            Text {
                id: lastYearEnergy
                text: "- kWh"
                font {
                    pointSize: 16
                    family: qfont.regular.name
                }
            }
        }
        Row {
            spacing: 20
            Text {
                text: "Last month"
                font {
                    pointSize: 18
                    family: qfont.bold.name
                }
            }
        }
        Row {
            spacing: 20
            Text {
                text: "Energy"
                font {
                    pointSize: 16
                    family: qfont.semiBold.name
                }
            }
            Text {
                id: lastMonthEnergy
                text: "- kWh"
                font {
                    pointSize: 16
                    family: qfont.regular.name
                }
            }
        }
        Row {
            spacing: 20
            Text {
                text: "Last day"
                font {
                    pointSize: 18
                    family: qfont.bold.name
                }
            }
        }
        Row {
            spacing: 20
            Text {
                text: "Energy"
                font {
                    pointSize: 16
                    family: qfont.semiBold.name
                }
            }
            Text {
                id: lastDayEnergy
                text: "- kWh"
                font {
                    pointSize: 16
                    family: qfont.regular.name
                }
            }
        }
        Row {
            spacing: 20
            Text {
                text: "--------------------"
                font {
                    pointSize: 18
                    family: qfont.bold.name
                }
            }
        }
        Row {
            spacing: 20
            Text {
                text: "Current power"
                font {
                    pointSize: 16
                    family: qfont.semiBold.name
                }
            }
            Text {
                id: currentPower
                text: "- W"
                font {
                    pointSize: 16
                    family: qfont.regular.name
                }
            }
        }
        
    }
}