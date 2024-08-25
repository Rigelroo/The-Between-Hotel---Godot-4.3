extends Node

class_name Canvas

@onready var inventory = $InventoryGui
@onready var player = preload("res://scenes/entities/player/Player.tscn")
@onready var hudbar = $Statsbar
@onready var staminabar = $staminabar
var canOpen_inventory : bool = true
@export var manager : CoinManager 




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _ready():
	inventory.readyclose()
	hudbar.visible = true
	Dialogic.signal_event.connect(_on_dialogic_signal)


# Called when the node enters the scene tree for the first time.
#
#@onready var label = $Control2/Label
#@onready var gameTimer = $Control2/Timer
#
#func _physics_process(delta):
	#var texttimer = str(time_to_minutes_secs_mili(gameTimer.get_time_left()))
	#label.call_deferred("set_text", texttimer)
#
#func time_to_minutes_secs_mili(time : float):
	#var mins = int(time) / 60
	#time -= mins * 60
	#var secs = int(time)
	#var mili = int((time - int(time)) * 100)
	#return str(mins) + ":" + str(secs)


func _input(event):
	if event.is_action_pressed("menu_inventory"):
		if canOpen_inventory:
			if inventory.isOpen:
				hudbar.visible = true
				inventory.close()
			else:
				inventory.open()
				hudbar.visible = false
	else: pass
	
func _on_dialogic_signal(argument:String):
	if argument == "deactivate_movement":
		print("Deactivate Movement!")
		canOpen_inventory = false
	if argument == "reactivate_movement":
		print("Reactivate Movement!")
		canOpen_inventory = true

var use_milliseconds : bool
