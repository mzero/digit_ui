import sys, time, json, os.path, os, subprocess, queue, threading, traceback
os.environ["QT_IM_MODULE"] = "qtvirtualkeyboard"
from signal import signal, SIGINT, SIGTERM
from time import sleep
from sys import exit
from collections import OrderedDict
# import random
from PySide2.QtGui import QGuiApplication
from PySide2.QtCore import QObject, QUrl, Slot, QStringListModel, Property, Signal, QTimer, QThreadPool, QRunnable
from PySide2.QtQml import QQmlApplicationEngine, qmlRegisterType
from PySide2.QtGui import QIcon
# # compiled QML files, compile with pyside2-rcc
# import qml.qml

os.environ["QT_IM_MODULE"] = "qtvirtualkeyboard"
import icons.icons
# #, imagine_assets
import resource_rc

EXIT_PROCESS = [False]
# import patch_bay_model


current_source_port = None
# current_effects = OrderedDict()
current_effects = {}
# current_effects["delay1"] = {"x": 20, "y": 30, "effect_type": "delay", "controls": {}, "highlight": False}
# current_effects["delay2"] = {"x": 250, "y": 290, "effect_type": "delay", "controls": {}, "highlight": False}
port_connections = {} # key is port, value is list of ports

context = None


if __name__ == "__main__":

    print("in Main")
    app = QGuiApplication(sys.argv)
    QIcon.setThemeName("digit")
    # Instantiate the Python object.
    # knobs = Knobs()

    # update_counter = PolyValue("update counter", 0, 0, 500000)
    # read persistant state
    # pedal_state = {}
    # with open("/pedal_state/state.json") as f:
    #     pedal_state = json.load(f)
    # current_bpm = PolyValue("BPM", 120, 30, 250) # bit of a hack
    # current_preset = PolyValue("Default Preset", 0, 0, 127)
    # update_counter = PolyValue("update counter", 0, 0, 500000)
    # command_status = [PolyValue("command status", -1, -10, 100000), PolyValue("command status", -1, -10, 100000)]
    # delay_num_bars = PolyValue("Num bars", 1, 1, 16)
    # midi_channel = PolyValue("channel", pedal_state["midi_channel"], 1, 16)
    # input_level = PolyValue("input level", pedal_state["input_level"], -80, 10)
    # knobs.set_input_level(pedal_state["input_level"], write=False)

    # available_effects = QStringListModel()
    # available_effects.setStringList(list(effect_type_map.keys()))
    engine = QQmlApplicationEngine()

    # qmlRegisterType(patch_bay_model.PatchBayModel, 'Poly', 1, 0, 'PatchBayModel')
    # Expose the object to QML.
    # global context
    context = engine.rootContext()
    # context.setContextProperty("knobs", knobs)
    # context.setContextProperty("available_effects", available_effects)
    # context.setContextProperty("selectedEffectPorts", selected_effect_ports)
    # context.setContextProperty("portConnections", port_connections)
    # context.setContextProperty("effectPrototypes", effect_prototypes)
    # context.setContextProperty("updateCounter", update_counter)
    # context.setContextProperty("currentBPM", current_bpm)
    # # context.setContextProperty("pluginState", plugin_state)
    # context.setContextProperty("currentPreset", current_preset)
    # context.setContextProperty("commandStatus", command_status)
    # context.setContextProperty("delayNumBars", delay_num_bars)
    # context.setContextProperty("midiChannel", midi_channel)
    # context.setContextProperty("isLoading", is_loading)
    # # context.setContextProperty("inputLevel", input_level)
    # context.setContextProperty("presetList", preset_list_model)
    # print("starting recv thread")
    engine.load(QUrl("qml/TestWrapper.qml"))
    # ingen_wrapper.start_recv_thread(ui_messages)
    # print("starting send thread")
    # ingen_wrapper.start_send_thread()
    # try:
    #     add_io()
    # except Exception as e:
    #     print("########## e is:", e)
    #     ex_type, ex_value, tb = sys.exc_info()
    #     error = ex_type, ex_value, ''.join(traceback.format_tb(tb))
    #     print("EXception is:", error)
    #     sys.exit()

    # sys._excepthook = sys.excepthook
    # def exception_hook(exctype, value, traceback):
    #     print("except hook got a thing!")
    #     sys._excepthook(exctype, value, traceback)
    #     sys.exit(1)
    # sys.excepthook = exception_hook
    # try:
    # crash_here
    # except:
    #     print("caught crash")
    # timer = QTimer()
    # timer.timeout.connect(tick)
    # timer.start(1000)

    def signalHandler(sig, frame):
        if sig in (SIGINT, SIGTERM):
            # print("frontend got signal")
            # global EXIT_PROCESS
            EXIT_PROCESS[0] = True
            # ingen_wrapper._FINISH = True
    signal(SIGINT,  signalHandler)
    signal(SIGTERM, signalHandler)
    # initial_preset = False
    print("starting UI")
    while not EXIT_PROCESS[0]:
        # debug_print("processing events")
        try:
            app.processEvents()
            # debug_print("processing ui messages")
        except Exception as e:
            qCritical("########## e is:"+ str(e))
            ex_type, ex_value, tb = sys.exc_info()
            error = ex_type, ex_value, ''.join(traceback.format_tb(tb))
            # debug_print("EXception is:", error)
            sys.exit()
        sleep(0.01)

    qWarning("mainloop exited")
    app.exit()
    sys.exit()
    qWarning("sys exit called")
