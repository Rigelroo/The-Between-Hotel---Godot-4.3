extends Area2D

class_name SplashDetector

@export var splashw : SplashWater
@onready var player = $".."
signal splash


func _on_body_entered(_body):
	var is_in_water = player.is_in_water
	if(is_in_water == false):
		var overlapping_bodies = get_overlapping_bodies()
		
		if (overlapping_bodies.size() > 0):
			splashw.can_create = true
			print(splashw.can_create)


func _on_body_exited(_body):
	var overlapping_bodies = get_overlapping_bodies()
	splashw.can_create = false
	if (overlapping_bodies.size() == 0):
		print(splashw.can_create)
