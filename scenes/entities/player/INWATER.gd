extends "state.gd"


func update(delta):
	Player.gravity(delta)
	if Player.velocity.x == 0:
		if !Player.is_in_water:
			return STATES.IDLE
	if Player.movement_input.x != 0:
		return STATES.SWIM
	if Player.jump_input_actuation == true:
		if !Player.is_in_water:
			$"../../AnimationPlayer".play("jump_start")
			return STATES.JUMP
	if Player.velocity.y >0:
		if !Player.is_in_water:
			$"../../AnimationPlayer".play("jump_end")
			return STATES.FALL
	if Player.dash_input and Player.can_dash:
		if !Player.is_in_water:
			return STATES.DASH
	if Player.attack_input  && !Player.can_interact:
		if !Player.is_in_water:
			return STATES.SLASH
	if Player.new_item_activate:
		$"../../AnimationPlayer".play("new_item")
		return STATES.NEWITEM
	if Player.dying:
		$"../../AnimationPlayer".play("Defeat")
		return STATES.DEATH
	if Input.is_action_just_pressed("Jump"):
		$"../../AnimationPlayer2".play("swim")
	return null
func enter_state():
	$"../../AnimationPlayer".stop()
	
