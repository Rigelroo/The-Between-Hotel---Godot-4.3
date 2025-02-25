extends Control

var is_paused := false

func proc():
	if Input.is_action_just_pressed("pause"):
		if !is_paused:
			$AnimationPlayer.play("hide")
			is_paused = true
		else:
			$AnimationPlayer.play("show")
			is_paused = false
