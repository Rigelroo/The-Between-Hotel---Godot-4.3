extends Node2D

#class_name ConfigManager

@export var mainvolume_value = 0
@export var musicvolume_value = 0
@export var sfxvolume_value = 0
@export var mudo = false

@export var screentype_value = 0
@export var screenresolution_value = 2
@export var vsync_value = false
@export var telacheia_value = false

@export var screenshader_value = null

const WINDOW_MODE_ARRAY : Array[String] = [
	"Full-Screen",
	"Window Mode",
	"Borderless Window",
	"Borderless Full-Screen"
	]

var RESOLUTION_DICT : Dictionary = {
	"800x600": Vector2i(800,600),
	"1600x900": Vector2i(1600,900),
	"1366x768": Vector2i(1366,768),
	"1280x720": Vector2i(1280,720),
	"2560x1140": Vector2i(2560,1140),
	"1920x1080": Vector2i(1920,1080)
}

func save_configs():
	var telaconfig_variables = [screentype_value, screenresolution_value, vsync_value, telacheia_value] 
	var somconfig_variables = [mainvolume_value, musicvolume_value, sfxvolume_value, mudo]
	#SaveSys.signalManager_dict["SignalManager"] = signal_manager_variables
	SaveSys.somconfig_dict = somconfig_variables
	SaveSys.telaconfig_dict = telaconfig_variables
	#SaveSys.controlesconfig_dict
	#SaveSys.languageconfig_dict

func load_configs():
	var saved_configs = SaveSys.load_config_from_slot(1)
	print(saved_configs)
	
	return saved_configs
