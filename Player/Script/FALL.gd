extends "state.gd"
@onready var CoyoteTimer = $CoyoteTimer
@export var coyote_duration = 0.2

var can_slide = false
var can_jump = true
var glider_timer

func update(delta):
	Player.handleJumpBuffer()
	if not Player.is_on_floor() and Player.get_next_to_wall():
		var next_to_wall = Player.get_next_to_wall()
		

		if (
			(next_to_wall == Vector2.RIGHT and Input.is_action_pressed("MoveRight")) or
			(next_to_wall == Vector2.LEFT and Input.is_action_pressed("MoveLeft"))
		):
			return STATES.SLIDE


	Player.velocity.y += Player.gravity(delta)
	Player.velocity.x = lerp(Player.prevVelocity.x, Player.velocity.x, Player.AIR_X_SMOOTHING)
	player_movement(delta)


	if Player.is_on_floor():
		can_slide = true
		return STATES.IDLE

	if Player.gliding_actuation:
		return STATES.HLEAF

	# Transição para DASH
	if Player.dash_input and Player.can_dash:
		return STATES.DASH



	#if not is_sliding and (
		#(next_to_wall == Vector2.RIGHT and Input.is_action_pressed("MoveRight")) or
		#(next_to_wall == Vector2.LEFT and Input.is_action_pressed("MoveLeft"))
		#):
	#if Player.get_next_to_wall() != null and !Player.is_in_water and can_slide:
		#return STATES.SLIDE


	if Player.attack_input and !Player.is_on_floor():
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

	if Player.is_dealing_damage:
		return STATES.HIT
	
	if Input.is_action_just_pressed("Jump"):
		print("ticks_msec ",Time.get_ticks_msec()," - ","lastFloorMsec ", Player.lastFloorMsec," = ", Time.get_ticks_msec() - Player.lastFloorMsec," < ", Player.COYOTE_TIME)
		if Time.get_ticks_msec() - Player.lastFloorMsec < Player.COYOTE_TIME:
			return STATES.JUMP
		else:
			Player.lastJump_msec = Time.get_ticks_msec()
	return null

func enter_state():
	
	$"../../AnimationPlayer".play("fall_start")
	print($"../../AnimationPlayer".current_animation)
	# Configurar coyote time
	if Player.prev_state in [STATES.IDLE, STATES.MOVE, STATES.SLIDE]:
		can_jump = true
		CoyoteTimer.start(coyote_duration)
	else:
		can_jump = false

	# Evitar reentrada imediata no estado SLIDE
	if Player.prev_state == STATES.SLIDE:
		can_slide = false
		await get_tree().create_timer(0.2).timeout
		can_slide = true
	

func exit_state():
	glider_timer = false
	$"../../AnimationPlayer".stop()
	Player.jump_particles()
	%Sprite2D.scale = Vector2(1,1)


func _on_coyote_timer_timeout():
	can_jump = false


#@onready var CoyoteTimer = $CoyoteTimer
#@export var coyote_duration = .2
#
#var can_jump = true
#func update(delta):
	#$"../../AnimationPlayer".play("jump")
	#Player.velocity.y += Player.gravity(delta)
	#player_movement()
	#if Player.is_on_floor():
		#can_slide = true
		#return STATES.IDLE
	#if Player.jump_input_actuation && !Player.is_on_floor() && Player.manager.hleaf_equiped:
		#return STATES.HLEAF
	#if Player.dash_input and Player.can_dash:
		#return STATES.DASH
	#if Player.get_next_to_wall() != null && !Player.is_in_water:
		#if can_slide:
			#print(Player.get_next_to_wall())
			#return STATES.SLIDE
	#if Player.jump_input_actuation and can_jump:
		#if !Player.is_in_water:
			#return STATES.JUMP
	##if Player.attack_input && !Player.is_on_floor():
		##return STATES.SLASH
	#if Player.attack_input && !Player.is_on_floor():
		#return STATES.AIRSLASH
	#if Player.new_item_activate:
		#$"../../AnimationPlayer".play("new_item")
		#return STATES.NEWITEM
		#
	#if Player.dying:
		#$"../../AnimationPlayer".play("Defeat")
		#return STATES.DEATH
		#
	#if Player.is_in_water:
		#$"../../AnimationPlayer2".play("idle_swimming")
		#return STATES.INWATER
	#if Player.is_dealing_damage == true:
		#return STATES.HIT
	#return null
#
#func enter_state():
	#
	#$"../../AnimationPlayer".play("jump")
	#if Player.prev_state == STATES.IDLE or Player.prev_state == STATES.MOVE or Player.prev_state == STATES.SLIDE:
		#can_jump = true
		#CoyoteTimer.start(coyote_duration)
	#else: 
		#can_jump = false
	#if Player.prev_state == STATES.SLIDE:
		#await get_tree().create_timer(1).timeout
		#can_slide = true
#
#func _on_coyote_timer_timeout():
	#can_jump = false
	#pass # Replace with function body.
#
#var can_slide = false
