extends "state.gd"

@onready var friction_particles: GPUParticles2D = $"../../Emitters/FrictionParticles"

var saved_speed = 705.0


func update(delta):
	Player.velocity.y += Player.gravity(delta)
	player_movement(delta)
	friction()
	Player.handleJumpBuffer()
	if Player.velocity.x == 0 or !Player.sprint_input:
		return STATES.MOVE

	#if Player.velocity.x == 0:
		#return STATES.IDLE
	if Player.velocity.y >0:
		return STATES.FALL
	if Player.jump_input_actuation:
		if !Player.is_in_water:
			friction_particles.emitting = false
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

func friction():
	if Player.is_on_floor():
		if Player.velocity.x > 10 or Player.velocity.x < -10:
			
			friction_particles.emitting = true
		if Player.movement_input.x == 0:
			friction_particles.emitting = false
	else:
		friction_particles.emitting = false

func enter_state():
	Player.is_jumping = false
	Player.can_dash = true
	$"../../AnimationPlayer".play("run")
