extends "state.gd"


func update(delta):
	Player.velocity.y += Player.gravity(delta)
	if Input.is_action_pressed("Balir"):
		$"../../AnimationPlayer".play("balir")
		
	
	
	if Player.movement_input.x != 0 and !Player.is_in_water:
		return STATES.MOVE
	if Player.jump_input_actuation:
		if !Player.is_in_water:
			$"../../AnimationPlayer".play("jump_start")
			return STATES.JUMP
	if Player.velocity.y >0 and !Player.is_in_water:
		$"../../AnimationPlayer".play("jump_end")
		return STATES.FALL
	if Player.dash_input and Player.can_dash && !Player.is_in_water:
		return STATES.DASH
	if Player.attack_input:
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
	if Player.breath_input:
		$"../../AnimationPlayer".play("breath_start")
		return STATES.BREATH
	if Player.is_dealing_damage:
		return STATES.HIT
	return null
func enter_state():
	Player.slashing = false
	Player.is_jumping = false
	Player.velocity.x = 0  # Para garantir que o movimento pare
	Player.movement_input.x = 0  # Reseta a entrada de movimento

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
	else:
		$"../../AnimationPlayer".play("idle")
	Player.can_dash = true


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "balir":
		$"../../AnimationPlayer".play("idle")
