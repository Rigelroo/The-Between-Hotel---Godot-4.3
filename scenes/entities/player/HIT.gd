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
	if Player.is_dealing_damage == true:
		return STATES.HIT
	if !owner.is_dealing_damage:
		return STATES.IDLE
	return null

func enter_state():
	
	%Hitboxcollision.disabled = true
	$NohitTimer.start(3)

func exit_state():
	owner.is_dealing_damage = false
	$"../../Sprite2D".material.set_shader_parameter("Active", false)


func _on_nohit_timer_timeout() -> void:
	%Hitboxcollision.disabled = false
