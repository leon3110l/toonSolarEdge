import QtQuick 2.1
import qb.components 1.0

Screen {

    screenTitle: "config"

    Column {
        anchors.centerIn: parent
        spacing: 5

        Text {
            text: "api key: " + app.settings.apiKey
            horizontalAlignment: Text.AlignHCenter
        }

        Text {
            text: "site id: " + app.settings.siteId
            horizontalAlignment: Text.AlignHCenter
        }
    }
}