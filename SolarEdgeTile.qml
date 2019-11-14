import QtQuick 2.1
import qb.components 1.0

Tile {

    onClicked: app.openScreen("graph")

    Text {
		id: tileTitle
		color: colors.tileTitleColor
		text: qsTr("Solar this moment")
		anchors {
			baseline: parent.top
			baselineOffset: Math.round(30 * verticalScaling)
			horizontalCenter: parent.horizontalCenter
		}
		font.pixelSize: qfont.tileTitle
		horizontalAlignment: Text.AlignLeft
		verticalAlignment: Text.AlignTop
		font.family: qfont.regular.name
	}

    Image {
        height: 60
        source: "./drawables/solar.svg"
        anchors.centerIn: parent
    }

    Text {
		id: tileText
		text: "-"
		anchors {
			horizontalCenter: parent.horizontalCenter
			baseline: parent.bottom
			baselineOffset: designElements.vMarginNeg16
		}
		verticalAlignment: Text.AlignBottom
		horizontalAlignment: Text.AlignRight
		font.pixelSize: qfont.tileText
		font.family: qfont.regular.name
		color: colors.tileTextColor
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
                tileText.text = wattage == 0 ? "-" : qsTr("%1 Watt").arg(wattage)
            }
        )
    }

}