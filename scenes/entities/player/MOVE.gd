extends "state.gd"

func update(delta):
	Player.gravity(delta)
	player_movement()
	if Player.velocity.x == 0:
		return STATES.IDLE
	if Player.velocity.y >0:
		return STATES.FALL
	if Player.jump_input_actuation:
		if !Player.is_in_water:
			return STATES.JUMP
	if Player.dash_input and Player.can_dash:
		return STATES.DASH
	if Player.attack_input && !Player.can_interact:
		return STATES.SLASH
	if Player.new_item_activate:
		$"../../AnimationPlayer".play("new_item")
		return STATES.NEWITEM
	if Player.dying:
		$"../../AnimationPlayer".play("Defeat")
		return STATES.DEATH
	if Player.is_in_water:
		$"../../AnimationPlayer2".play("idle_swimming")
		return STATES.INWATER
	if Player.is_dealing_damage == true:
		return STATES.HIT
	return null
func enter_state():
	Player.is_jumping = false
	Player.can_dash = true
	$"../../AnimationPlayer".play("run")
