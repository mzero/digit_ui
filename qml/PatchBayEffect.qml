import QtQuick 2.4
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.3
// list for inputs, outputs
// each has a type, id, name.  icon? 
// effect has name, internal name / class, id
//
// later exposed parameters
//
import "polyconst.js" as Constants

Rectangle {
    id: rect
    width: 114
    height: 68
    radius: 6
    // color: patch_bay.delete_mode ? Qt.rgba(0.9,0.0,0.0,1.0) : Qt.rgba(0.3,0.3,0.3,1.0)  
    color: Constants.background_color
    z: mouseArea.drag.active ||  mouseArea.pressed || selected ? 4 : 1
    // color: Material.color(time_scale.delay_colors[index])
    // color: Qt.rgba(0, 0, 0, 0)
    // color: setColorAlpha(Material.Pink, 0.1);//Qt.rgba(0.1, 0.1, 0.1, 1);
    property point beginDrag
    property bool caught: false
    property string effect_id
    property string effect_type
    property color effect_color: Constants.audio_color
    property bool highlight: false
    property bool selected: false
    property var sliders; 
    // border { width:2; color: Material.color(Material.Cyan, Material.Shade100)}
    Drag.active: mouseArea.drag.active

    function connect_clicked() {
        /*
         * on click, check if we are highlight, if not find source ports 
         * if we are, then we're a current target
         */
        if (!highlight){
            knobs.select_effect(true, effect_id)
            patch_bay.list_effect_id = effect_id;
            patch_bay.list_source = true;

            var k = Object.keys(effectPrototypes[effect_type]["outputs"])
            if (k.length > 1 )
            {
                mainStack.push(portSelection);
            } 
            else {
                knobs.set_current_port(true, effect_id, k[0]);
                rep1.model.items_changed();
                patch_bay.externalRefresh();
            }
        } else {
            knobs.select_effect(false, effect_id)
            patch_bay.list_effect_id = effect_id;
            patch_bay.list_source = false;

            var k = Object.keys(effectPrototypes[effect_type]["inputs"])
            if (k.length > 1 )
            {
                mainStack.push(portSelection);
            } 
            else {
                knobs.set_current_port(false, effect_id, k[0]);
                rep1.model.items_changed();
                patch_bay.externalRefresh();
            }
        }

    }

    function delete_clicked() {
        // delete current effect
        // console.log("clicked", display);
        // rep1.model.remove_effect(display)
        console.log("deleting", effect_id);
        knobs.remove_effect(effect_id);
        patch_bay.externalRefresh();
    }

    function expand_clicked () {
        if (effect_type == "stereo_EQ" || effect_type == "mono_EQ"){
            mainStack.push("EQWidget.qml", {"effect": effect_id});
        }
        else if (effect_type == "delay"){
            mainStack.push(editDelay);
        }
        else if (effect_type == "mono_reverb" || effect_type == "stereo_reverb" || effect_type == "true_stereo_reverb")
        {
            mainStack.push("ReverbBrowser.qml", {"effect": effect_id, 
            "top_folder": "file:///audio/reverbs",
            "after_file_selected": (function(name) { 
                // console.log("got new reveb file");
                // console.log("file is", name.toString());
                knobs.update_ir(effect_id, name.toString());
                })
            });
        }
        else if (effect_type == "mono_cab" || effect_type == "stereo_cab" || effect_type == "true_stereo_cab"){
            mainStack.push("ReverbBrowser.qml", {"effect": effect_id, 
            "top_folder": "file:///audio/cabs",
            "after_file_selected": (function(name) { 
                // console.log("got new reveb file");
                // console.log("file is", name.toString());
                knobs.update_ir(effect_id, name.toString());
                })
            });
        }
        else if (effect_type == "input" || effect_type == "output"){
            // pass
        } else {
            // mainStack.push(editGeneric);
        }
    }

    function disconnect_clicked()
    {
        /*
         * on click, if there's just one port then connected then disconnect it
         * otherwise list connected
         */
        knobs.list_connected(effect_id);
        // * on click if highlighted (valid port)
        // * show select target port if port count > 1
        patch_bay.list_effect_id = effect_id;
        patch_bay.list_source = false;
        mainStack.push(disconnectPortSelection);
        // select target, show popup with target ports
        // } 
        // else {
        // knobs.set_current_port(false, effect_id, ) // XXX

        // }
    }

    border { width:2; color: selected ? Constants.accent_color : Constants.outline_color}

    Column {
        width:5
        y:20
        anchors.left: parent.left
        Repeater {
            id: outputRep
            model: Object.keys(effectPrototypes[effect_type]["outputs"]) 
            Rectangle {
                anchors.left: parent.left
                anchors.leftMargin: 0
                width: 2
                height: 8
                color: Constants.audio_color
            }
        }
    }

    Column {
        width:5
        anchors.right: parent.right
        y:20
        Repeater {
            id: inputRep
            model: Object.keys(effectPrototypes[effect_type]["inputs"]) 
            Rectangle {
                anchors.right: parent.right
                anchors.rightMargin: 0
                width: 2
                height: 8
                color: highlight ? Constants.accent_color : Constants.audio_color
            }
        }
	}

    Rectangle {
        anchors.verticalCenter: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        width: 30
        height: 30
        radius: 15
        color: Constants.background_color
        border { width:2; color: Constants.control_color}
        Label {
            anchors.centerIn: parent
            text: Object.keys(effectPrototypes[effect_type]["controls"]).length
            // height: 15
            color: Constants.control_color
            font {
                // pixelSize: fontSizeMedium
                pixelSize: 18
                capitalization: Font.AllUppercase
            }
        }
    }

    Label {
        anchors.top: parent.top
        anchors.topMargin: 8
        anchors.horizontalCenter: parent.horizontalCenter
        text: effect_id.replace("_", " ")
        height: 36
        color: effect_color
        font {
            // pixelSize: fontSizeMedium
            pixelSize: 23
            capitalization: Font.AllUppercase
        }
    }
    //
    MouseArea {
        id: mouseArea
        z: -1
        anchors.fill: parent
        drag.target: parent
        onPressed: {
            // check mode: move, delete, connect, open
            rect.beginDrag = Qt.point(rect.x, rect.y);
			console.log("effect proto", Object.keys(effectPrototypes[effect_type]["inputs"]))

            if (!patch_bay.anythingSelected){
                selected = true
                patch_bay.anythingSelected = true
                patch_bay.selected_effect = rect
                // bring up sliders/controls, and icons
                // if we're past left of center sliders on right
                // else sliders on left
                // selected changes z via binding
                if (rect.x > 640){
                    sliders = editGeneric.createObject(patch_bay, {x: 0, y: 0});
                    action_icons.x = rect.x + 130; // bound max
                } else {
                    sliders = editGeneric.createObject(patch_bay, {x: 700, y: 0});
                    action_icons.x = rect.x - 90; // and min
                }
                action_icons.visible = true;
                return;
            }
            else if (patch_bay.currentMode == PatchBay.Connect){
                connect_clicked();
            }
            else if (patch_bay.currentMode == PatchBay.Move){
				patch_bay.isMoving = true;
				patch_bay.externalRefresh();
			}
        }
        onDoubleClicked: {
            // time_scale.current_delay = index;
            // mainStack.push(editDelay);
            // mappingPopup.set_mapping_choice("delay"+(index+1), "Delay_1", "TIME", 
            //     "delay"+(index+1), time_scale.current_parameter, 
            //     time_scale.inv_parameter_map[time_scale.current_parameter], false);    
            // remove MIDI mapping
            // add MIDI mapping
        }
        onReleased: {
            // var in_x = rect.x;
            // var in_y = rect.y;
            if (patch_bay.currentMode == PatchBay.Move){
				patch_bay.isMoving = false;
				patch_bay.externalRefresh();
				knobs.move_effect(effect_id, rect.x, rect.y)
			
			}

            // if(!rect.caught) {
            // // clamp to bounds
            // in_x = Math.min(Math.max(-(width / 2), in_x), mycanvas.width - (width / 2));
            // in_y = Math.min(Math.max(-(width / 2), in_y), mycanvas.height - (width / 2));
            // }
            // if(time_scale.snapping && time_scale.synced) {
            //     in_x = time_scale.nearestDivision(in_x + (width / 2)) - (width / 2);
            // }
            // in_x = in_x + (width / 2);
            // in_y = in_y + (width / 2);
            // knobs.ui_knob_change("delay"+(index+1), "Delay_1", time_scale.pixelToTime(in_x));
            // knobs.ui_knob_change("delay"+(index+1), 
            // time_scale.current_parameter, 
            // time_scale.pixelToValue(time_scale.delay_data[index][time_scale.current_parameter].rmin, 
            // time_scale.delay_data[index][time_scale.current_parameter].rmax, 
            // in_y)); 
            // console.log("parameter map", 
            // time_scale.current_parameter, "value", 
            // time_scale.pixelToValue(in_y),
            // "rect.y", rect.y, "in_y", in_y);
        }

    }
    ParallelAnimation {
        id: backAnim
        SpringAnimation { id: backAnimX; target: rect; property: "x"; duration: 500; spring: 2; damping: 0.2 }
        SpringAnimation { id: backAnimY; target: rect; property: "y"; duration: 500; spring: 2; damping: 0.2 }
    }

        Component {
            id: editDelay
            Item {
                height:700
                width:1280
                Column {
                    width: 1100
                    spacing: 20
                    anchors.centerIn: parent
                
                    GlowingLabel {
                        color: "#ffffff"
                        text: effect_id
                        font {
                            pixelSize: fontSizeLarge
                        }
                    }
                    // property var parameter_map: {"LEVEL":"Amp_5", "TONE":"", "FEEDBACK": "", 
                    //                 "GLIDE": "", "WARP":""  }
                    DelayRow {
                        row_param: "Delay_1"
						current_effect: effect_id
                    }
                    Row {
                        height: 40
                        spacing: 25

                        Slider {
                            title: "TIME (ms)" 
                            width: 625
							value: currentEffects[effect_id]["controls"]["Delay_1"].value
							from: currentEffects[effect_id]["controls"]["Delay_1"].rmin
							to: currentEffects[effect_id]["controls"]["Delay_1"].rmax
                            onMoved: {
								knobs.ui_knob_change(effect_id, "Delay_1", value);
                            }

                        }

                        SpinBox {
                            value: currentEffects[effect_id]["controls"]["Delay_1"].value * (60 / currentBPM.value) * 1000
                            from: currentEffects[effect_id]["controls"]["Delay_1"].rmin * (60 / currentBPM.value) * 1000
                            to:  currentEffects[effect_id]["controls"]["Delay_1"].rmax * (60 / currentBPM.value) * 1000
                            stepSize: 10
                            // editable: true
                            onValueModified: {
								knobs.ui_knob_change(effect_id, "Delay_1", value / 1000 / (60 / currentBPM.value));
                            }
                        }
                    }
                    DelayRow {
                        row_param: "Amp_5"
						current_effect: effect_id
                    }
                    DelayRow {
                        row_param: "FeedbackSm_6"
						current_effect: effect_id
                    }
                    DelayRow {
                        row_param: "Feedback_4"
						current_effect: effect_id
                    }
                    DelayRow {
                        row_param: "DelayT60_3"
						current_effect: effect_id
                    }
                    DelayRow {
                        row_param: "Warp_2"
						current_effect: effect_id
                    }
                    // DelayRow {
                    //     row_param: "carla_level"
                    // }
                }
                

                Button {
                    font {
                        pixelSize: fontSizeMedium
                    }
                    text: "BACK"
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    anchors.topMargin: 10
                    width: 100
                    height: 100
                    onClicked: mainStack.pop()
                }
            }
        }

        Component {
            id: editGeneric
            Item {
                height:540
                width:500
                Column {
                    width: 500
                    spacing: 35
                    anchors.centerIn: parent

					Repeater {
						model: Object.keys(currentEffects[effect_id]["controls"])
						DelayRow {
							row_param: modelData
							current_effect: effect_id
						}
					}
                }
                
            }
        }

}
