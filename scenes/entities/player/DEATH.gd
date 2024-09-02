extends "state.gd"


func update(delta):
	Player.gravity(delta)

	
	return null
func enter_state():
	
	await $"../../AnimationPlayer".animation_finished
	Player.death.emit()
		
