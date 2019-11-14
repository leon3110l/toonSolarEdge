import QtQuick 2.1
import qb.components 1.0

Tile {

    onClicked: app.openScreen("graph")
    
    Text {
        text: "zonnepanelen"
        color: colors.tileTitleColor

        font {
            pixelSize: qfont.tileTitle
            family: qfont.regular.name
        }

        anchors {
            horizontalCenter: parent.horizontalCenter
            topMargin: 35
        }
    }

    Image {
        height: 60
        source: "./drawables/solar.svg"
        anchors.centerIn: parent
    }

    Text {
        id: wattageText
        text: "- W"
        color: colors.tileTextColor

        font {
            pixelSize: qfont.tileTitle + 5
            family: qfont.regular.name
        }

        anchors {
            horizontalCenter: parent.horizontalCenter
            bottomMargin: 5
            bottom: parent.bottom
        }
    }

    Timer {
        interval: app.settings.updateFreq
        triggeredOnStart: true
        running: true
        repeat: true
        onTriggered: update()
    }

    function update() {

        app.getData(
            "overview",
            function(overview) {
                var wattage = overview.currentPower.power
                if(!wattage) {
                    wattage = "0"
                }
                wattageText.text = wattage + " W"
            }
        )
    }

}