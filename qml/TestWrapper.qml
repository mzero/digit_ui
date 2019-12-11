
import QtQuick 2.4
import QtQuick.Window 2.2
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.3

import "polyconst.js" as Constants

ApplicationWindow {

    Material.theme: Material.Dark
    Material.primary: Constants.control_color
    Material.accent: Constants.accent_color
    Material.background: "black"
    // Material.buttonColor: "grey"
    contentOrientation: Qt.LandscapeOrientation

    readonly property int baseFontSize: 20 
    readonly property int tabHeight: 60 
    readonly property int fontSizeExtraSmall: baseFontSize * 0.8
    readonly property int fontSizeMedium: baseFontSize * 1.5
    readonly property int fontSizeLarge: baseFontSize * 2
    readonly property int fontSizeExtraLarge: baseFontSize * 5
    width: 1280
    height: 720
    title: "Digit 2"
    visible: true
    // FontLoad0er { source: "ionicons.ttf" }
    //00
    FontLoader { id: mainFont; source: "fonts/Dosis-VF.ttf" }
    font.family: mainFont.name
    font.weight: Font.Medium
    Component {
        id: mainView
        // PatchBay {
        // }
        TitleFooter {
        }

        // Item {
        //     width: 1280
        //     height: 720
        
        // Slider {
        //     x: 50
        //     y: 50
        //     width: 625
        //     height: 48
        //     value: 0.5
        //     from: 0
        //     to: 1
        //     title: "Fragment Length"
        // }

        // Slider {
        //     x: 100
        //     y: 300
        //     value: 0.5
        //     from: 0
        //     to: 1
        //     title: "Fragment"
        //     orientation: Qt.Vertical
        //     width: 50 
        //     height: 300
        // }

        // Slider {
        //     x: 200
        //     y: 300
        //     value: 0.5
        //     from: 0
        //     to: 1
        //     title: "Gain"
        //     orientation: Qt.Vertical
        //     width: 75 
        //     height: 300
        // }

        // Slider {
        //     x: 300
        //     y: 300
        //     value: 0.5
        //     from: 0
        //     to: 1
        //     title: "Gain"
        //     orientation: Qt.Vertical
        //     width: 75 
        //     height: 200
        // }
        // // Switch {
        // //     x: 50
        // //     y: 50
        // //     text: qsTr("BAND 5")
        // //     font.pixelSize: baseFontSize
        // //     bottomPadding: 0
        // //     // height: 20
        // //     // implicitWidth: 100
        // //     width: 175
        // //     height: 30
        // //     leftPadding: 0
        // //     topPadding: 0
        // //     rightPadding: 0
        // // }

        // SpinBox {
        //     x: 100
        //     y: 100
        //     height: 50
        //     value: 10
        //     from: 1
        //     to:  100
        //     stepSize: 10
        // }
    // }
    }
    // // EQWidget {
    
    // }
    // PresetSave {
    // }
    // Settings {
    
    // }
    // EnvelopeFollower {

    // }
    
    // FolderBrowser {
   		// height: 400
    //     width: 300 
    //     top_folder: "file:///c:/git_repos/PolyDigit/UI" 
    //     after_file_selected: (function(name) { 
    //         console.log("in test wrapper call");
    //         console.log("file  is", name.toString());
            
    //     })

    // }
    StackView {
        id: mainStack
        initialItem: mainView
    }
}
