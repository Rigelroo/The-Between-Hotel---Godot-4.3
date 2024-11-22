extends Resource

class_name ConfigManager

@export var mainvolume_value = 0
@export var musicvolume_value = 0
@export var sfxvolume_value = 0

@export var screentype_value = null
@export var screentesolution_value = null
@export var vsync_value = false
@export var telacheia_value = false
@export_enum("Warrior", "Magician", "Thief") var character_class: int
@export var x = WINDOW_MODE_ARRAY

enum NamedEnum {Full_Screen, Window_Mode, Borderless_Window, Borderless}
@export var xy: NamedEnum

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
