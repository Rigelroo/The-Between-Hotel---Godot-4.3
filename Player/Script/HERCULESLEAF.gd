#extends "state.gd"
#
#@onready var CoyoteTimer = $CoyoteTimer
#@export var coyote_duration = .2
#var is_skidiving = false
#var can_jump = true
#func update(delta):
	#Player.gravity(delta)
	#player_movement()
	#if Player.is_on_floor():
		#return STATES.IDLE
	#if Player.dash_input and Player.can_dash:
		#return STATES.DASH
	#if Player.get_next_to_wall() != null:
		#return STATES.SLIDE
	#if Player.jump_input_actuation and can_jump:
		#return STATES.JUMP
	#if Player.attack_input && !Player.is_jumping:
		#return STATES.SLASH
	#if Player.attack_input && Player.is_jumping:
		#return STATES.AIRSLASH
	#if Player.new_item_activate:
		#$"../../AnimationPlayer".play("new_item")
		#return STATES.NEWITEM
	#if Player.is_in_water:
		#$"../../AnimationPlayer2".play("idle_swimming")
		#return STATES.INWATER
	#return null
#
#func enter_state():
	## Set the default gravity strength to 980.
	#is_skidiving = true
	#Player.velocity.y = Player.JUMP_VELOCITY
	#Player.is_jumping = true
	#$"../../AnimationPlayer".play("HerculesLeaf_start")
	#await $"../../AnimationPlayer".animation_finished
	#Player.is_skydiving = true
	#if Player.movement_input.x == 0:
		#$"../../AnimationPlayer".play("HerculesLeaf_nomove")
	#elif Player.movement_input.x != 0:
		#$"../../AnimationPlayer".play("HerculesLeaf_moving")
	#if Player.prev_state == STATES.IDLE or Player.prev_state == STATES.MOVE or Player.prev_state == STATES.SLIDE:
		#can_jump = true
		#CoyoteTimer.start(coyote_duration)
	#else: 
		#can_jump = false
	#
#
#func exit_state():
	#is_skidiving = false
	#Player.is_skydiving = false
#
#
#func _process(delta: float) -> void:
	#if is_skidiving:
		#if Player.movement_input.x == 0:
			#$"../../AnimationPlayer".play("HerculesLeaf_nomove")
		#elif Player.movement_input.x != 0:
			#$"../../AnimationPlayer".play("HerculesLeaf_moving")
#
#func _on_coyote_timer_timeout():
	#can_jump = false
	#pass # Replace with function body.
extends "state.gd"

@onready var CoyoteTimer = $CoyoteTimer
@export var coyote_duration = .2
var is_skydiving = false
var can_jump = true

func update(delta):
	Player.velocity.y += Player.gravity(delta)
	player_movement(delta)
	if !Player.gliding_actuation:
		if Player.is_on_floor():
			return STATES.IDLE
		if Player.dash_input and Player.can_dash:
			return STATES.DASH
		if Player.get_next_to_wall() != null:
			return STATES.SLIDE
		if Player.jump_input_actuation and can_jump:
			return STATES.JUMP
		if Player.attack_input && !Player.is_jumping:
			return STATES.SLASH
		if Player.attack_input && Player.is_jumping:
			return STATES.AIRSLASH
		return STATES.FALL


	if Player.is_on_floor():
		return STATES.IDLE
	if Player.dash_input and Player.can_dash:
		return STATES.DASH
	if Player.get_next_to_wall() != null:
		return STATES.SLIDE
	if Player.jump_input_actuation and can_jump:
		return STATES.JUMP
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
	
	return null

func enter_state():
	
	is_skydiving = true
	Player.velocity.y = Player.JUMP_VELOCITY / 1.5
	Player.is_jumping = true
	$"../../AnimationPlayer".play("HerculesLeaf_start")
	await $"../../AnimationPlayer".animation_finished
	Player.is_skydiving = true
	
	if Player.movement_input.x == 0:
		$"../../AnimationPlayer".play("HerculesLeaf_nomove")
	else:
		$"../../AnimationPlayer".play("HerculesLeaf_moving")
	
	if Player.prev_state in [STATES.IDLE, STATES.MOVE, STATES.SLIDE]:
		can_jump = true
		CoyoteTimer.start(coyote_duration)
	else: 
		can_jump = false

func exit_state():
	is_skydiving = false
	Player.is_skydiving = false

func _physics_process(delta: float) -> void:
	if is_skydiving:
		if Input.is_action_pressed("Jump"):
			pass
		if Player.movement_input.x == 0:
			$"../../AnimationPlayer".play("HerculesLeaf_nomove")
		else:
			$"../../AnimationPlayer".play("HerculesLeaf_moving")

func _on_coyote_timer_timeout():
	can_jump = false
