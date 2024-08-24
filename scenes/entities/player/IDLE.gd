extends "state.gd"


func update(delta):
	Player.gravity(delta)
	if Player.movement_input.x != 0 && !Player.is_in_water:
		return STATES.MOVE
	if Player.jump_input_actuation == true:
		if !Player.is_in_water:
			$"../../AnimationPlayer".play("jump_start")
			return STATES.JUMP
	if Player.velocity.y >0 && !Player.is_in_water:
		$"../../AnimationPlayer".play("jump_end")
		return STATES.FALL
	if Player.dash_input and Player.can_dash && !Player.is_in_water:
		return STATES.DASH
	if Player.attack_input == true:
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
	if Player.breath_input == true:
		$"../../AnimationPlayer".play("breath_start")
		return STATES.BREATH
	return null
func enter_state():
	Player.slashing = false
	Player.is_skydiving = false
	Player.is_jumping = false
	if Player.prev_state == STATES.FALL:
		$"../../AnimationPlayer".play("jump_end")
		await $"../../AnimationPlayer".animation_finished
		$"../../AnimationPlayer".play("idle")
	if Player.prev_state == STATES.HLEAF:
		$"../../AnimationPlayer".play("jump_end")
		await $"../../AnimationPlayer".animation_finished
		$"../../AnimationPlayer".play("idle")
	if Player.prev_state == STATES.MOVE:
		$"../../AnimationPlayer".play("idle")
	Player.can_dash = true
