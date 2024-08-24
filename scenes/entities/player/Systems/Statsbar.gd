extends Control

class_name StatsBar


@onready var player = Global.player_body

func _ready() -> void:
	player.healthChanged.connect(updatehealth)
	player.inkChanged.connect(updateink)
	updatehealth()
	
	updateink()


func updatehealth():
	$Healthbar.value = player.currentHealth * 100 / player.maxHealth
	
func updateink():
	$Inkbar.value = player.currentInk * 100 / player.maxInk
	
