import QtQuick 2.1
import qb.base 1.0
import FileIO 1.0

App {
    property url tileUrl: "SolarEdgeTile.qml"
    property url configScreenUrl: "ConfigScreen.qml"
    property url graphScreenUrl: "GraphScreen.qml"
    property url overviewScreenUrl: "OverviewScreen.qml"

    property ConfigScreen configScreen
    property GraphScreen graphScreen
    property OverviewScreen overviewScreen

    property variant settings: {
        "apiKey": "",
        "siteId": "",
        "updateFreq": 600000
    }

    property variant cacheData: {
        'overview': null,
        'powerGraph': null,
        'energyGraph': null
    }
    // the resolve callback expects data
    property variant dataResolvers: {
        'overview': function(resolve) {
            var url = "https://monitoringapi.solaredge.com/site/"+ settings.siteId +"/overview.json?api_key=" + settings.apiKey
            fetch(
                url,
                function(res) {
                    var data = JSON.parse(res.response)
                    resolve(data.overview)
                },
                "GET"
            )
        },
        'powerGraph': function(resolve, options) {

            const today = new Date()
            const tomorrow = new Date();
            tomorrow.setDate(today.getDate() + 1)

            const defaults = {
                startTime: today.getFullYear()+"-"+(today.getMonth() + 1)+"-"+today.getDate()+" 00:00:00",
                endTime: tomorrow.getFullYear()+"-"+(tomorrow.getMonth() + 1)+"-"+tomorrow.getDate()+" 00:00:00",
            }
            options = mergeOptions(defaults, options)

            var url = "https://monitoringapi.solaredge.com/site/"+ settings.siteId +"/power.json?api_key="+ settings.apiKey +"&startTime="+options.startTime+"&endTime=" + options.endTime
            fetch(
                url,
                function(res) {
                    var data = JSON.parse(res.response)
                    resolve(data.power)
                },
                "GET"
            )
        },
        'energyGraph': function(resolve, options) {
            var url = "https://monitoringapi.solaredge.com/site/"+ settings.siteId +"/energy.json?api_key="+ settings.apiKey +"&startDate=2019-10-01&endDate=2019-10-31"
            fetch(
                url,
                function(res) {
                    resolve(JSON.parse(res.response))
                },
                "GET"
            )
        }
    }

    function init() {
        const args = {
            thumbCategory: "general",
            thumbLabel: "SolarEdge",
            thumbIcon: "./drawables/solar.svg",
            thumbIconVAlignment: "center",
            thumbWeight: 30
        }

        registry.registerWidget("tile", tileUrl, this, null, args);
        registry.registerWidget("screen", configScreenUrl, this, "configScreen");
        registry.registerWidget("screen", graphScreenUrl, this, "graphScreen");
        registry.registerWidget("screen", overviewScreenUrl, this, "overviewScreen");
    }

    Component.onCompleted: {
        loadSettings()
    }

    function fetch(url, callback, method) {

        if(!method) {
            method = "GET"
        }

        var req = new XMLHttpRequest()
        req.onreadystatechange = function() {
            if(req.readyState == XMLHttpRequest.DONE && req.status == 200) {
                callback(req);
            }
        }
        req.open(method, url)
        req.send()
        
    }

    function setData(key, data, options) {
        cacheData[key] = {
            'lastUpdate': Date.now(),
            'data': data,
            'options': options
        }
    }

    function getData(key, callback, options, forceRefresh) {

        if(forceRefresh || (!cacheData[key] || !cacheData[key]["data"] || (Date.now() - cacheData[key]["lastUpdate"]) >= settings.updateFreq) || JSON.stringify(options) != JSON.stringify(cacheData[key]["options"])) {
            // refresh/get data
            if(dataResolvers[key]) {
                dataResolvers[key](function(data) {
                    setData(key, data, options)
                    callback(cacheData[key]["data"])
                }, options)
            }
        }
        if(cacheData[key] && cacheData[key]["data"]) {
            callback(cacheData[key]["data"])
            return cacheData[key]["data"]; // return old/instant data
        }
    }

    function openScreen(name) {

        switch(name) {
            case "config":
                if(this.configScreen) this.configScreen.show()
                break;
            case "graph":
                if(this.graphScreen) this.graphScreen.show()
                break;
            case "overview":
                if(this.overviewScreen) this.overviewScreen.show()
                break;
            default:
                if(this.configScreen) this.configScreen.show()
        }

    }

    function mergeOptions(defaults, options) {
        return Object.assign(defaults, options)
    }

    function loadSettings() {
        try {
            settings = JSON.parse(userSettingsFile.read())
        } catch(e) {}
    }

    function saveSettings() {
        var saveFile = new XMLHttpRequest();
		saveFile.open("PUT", "file:///HCBv2/qml/apps/solarEdge/userSettings.json");
		saveFile.send(JSON.stringify(settings));
    }

    FileIO {
        id: userSettingsFile
        source: "./userSettings.json"
    }
}