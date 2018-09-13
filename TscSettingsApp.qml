import QtQuick 1.1
import BxtClient 1.0

import qb.components 1.0
import qb.base 1.0

App {
	id: tscSettingsApp

	property url tscFrameUrl: "TscFrame.qml"
	property url rotateTilesScreenUrl: "RotateTilesScreen.qml"
	property url hideToonLogoScreenUrl: "HideToonLogoScreen.qml"

	function init() {
		registry.registerWidget("settingsFrame", tscFrameUrl, this, "tscFrame", {categoryName: "TSC", categoryWeight: 310});
		registry.registerWidget("screen", rotateTilesScreenUrl, this, null, {lazyLoadScreen: true});
		registry.registerWidget("screen", hideToonLogoScreenUrl, this, null, {lazyLoadScreen: true});

	}

        Component.onCompleted: {
                // load the settings on completed is recommended instead of during init
                loadSettings();
        }

        function loadSettings()  {
                var settingsFile = new XMLHttpRequest();
                settingsFile.onreadystatechange = function() {
                        if (settingsFile.readyState == XMLHttpRequest.DONE) {
                                if (settingsFile.responseText.length > 0)  {
                                        var temp = JSON.parse(settingsFile.responseText);
                                        for (var setting in globals.tsc) {
                                                if (!temp[setting])  { temp[setting] = globals.tsc[setting]; } // use default if no saved setting exists
                                        }
                                        globals.tsc = temp;
					if (stage.logo) stage.logo.visible = (globals.tsc["hideToonLogo"] !== 2 );
                                }
                        }
                }
                settingsFile.open("GET", "file:///HCBv2/qml/config/tsc.settings", true);
                settingsFile.send();
        }

	function saveGlobalsTsc() {
                // save the new settings into the json file
                var saveFile = new XMLHttpRequest();
                saveFile.open("PUT", "file:///HCBv2/qml/config/tsc.settings");
                saveFile.send(JSON.stringify(globals.tsc));
	}
}