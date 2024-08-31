extends "state.gd"

@onready var CoyoteTimer = $CoyoteTimer
@export var coyote_duration = .2

var can_jump = true
func update(delta):
	Player.gravity(delta)
	player_movement()
	if Player.is_on_floor():
		return STATES.IDLE
	if Player.jump_input_actuation && !Player.is_on_floor() && Player.manager.hleaf_equiped:
		return STATES.HLEAF
	if Player.dash_input and Player.can_dash:
		return STATES.DASH
	if Player.get_next_to_wall() != null && !Player.is_in_water:
		return STATES.SLIDE
	if Player.jump_input_actuation and can_jump:
		if !Player.is_in_water:
			return STATES.JUMP
	#if Player.attack_input && !Player.is_on_floor():
		#return STATES.SLASH
	if Player.attack_input && !Player.is_on_floor():
		return STATES.AIRSLASH
	if Player.new_item_activate:
		$"../../AnimationPlayer".play("new_item")
		return STATES.NEWITEM
		
	if Player.dying:
		$"../../AnimationPlayer".play("Defeat")
		return STATES.DEATH
		
	if Player.is_in_water:
		$"../../AnimationPlayer2".play("idle_swimming")
		return STATES.INWATER
	return null

func enter_state():
	$"../../AnimationPlayer".play("jump")
	if Player.prev_state == STATES.IDLE or Player.prev_state == STATES.MOVE or Player.prev_state == STATES.SLIDE:
		can_jump = true
		CoyoteTimer.start(coyote_duration)
	else: 
		can_jump = false

func _on_coyote_timer_timeout():
	can_jump = false
	pass # Replace with function body.
