extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

@onready var label = $Label
@onready var gameTimer = $Timer

func _physics_process(delta):
	var texttimer = str(time_to_minutes_secs_mili(gameTimer.get_time_left()))
	label.call_deferred("set_text", texttimer)

func time_to_minutes_secs_mili(time : float):
	var mins = int(time) / 60
	time -= mins * 60
	var secs = int(time)
	var mili = int((time - int(time)) * 100)
	return str(mins) + ":" + str(secs)
