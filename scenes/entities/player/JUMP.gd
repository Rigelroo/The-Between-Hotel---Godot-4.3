extends "state.gd"

func update(delta):
	Player.gravity(delta)
	player_movement()
	if Player.velocity.y >0:
		return STATES.FALL
	if Player.dash_input and Player.can_dash:
		return STATES.DASH
	if Player.attack_input && !Player.is_jumping:
		return STATES.SLASH
	if Player.attack_input && Player.is_jumping:
		return STATES.AIRSLASH
	if Player.new_item_activate:
		$"../../AnimationPlayer".play("new_item")
		return STATES.NEWITEM
	if Player.is_in_water:
		$"../../AnimationPlayer2".play("idle_swimming")
		return STATES.INWATER
	if Player.dying:
		$"../../AnimationPlayer".play("Defeat")
		return STATES.DEATH
	return null
func enter_state():
	
	if Player.prev_state == STATES.SLIDE:
		#Player.velocity.x = 1500#Player.movement_input = 1
		#Player.velocity.y = Player.JUMP_VELOCITY
		Player.is_jumping = true
		$"../../AnimationPlayer".play("jump_start")
	else:
		Player.velocity.y = Player.JUMP_VELOCITY
		Player.is_jumping = true
		$"../../AnimationPlayer".play("jump_start")
	await $"../../AnimationPlayer".animation_finished
	$"../../AnimationPlayer".play("jump")
