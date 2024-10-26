extends "state.gd"


@export var climb_speed = 50
@export var slide_friction = .7
@export var is_sliding = 0
func update(delta):
	$"../../AnimationPlayer".play("slide")
	slide_movement(delta)
	if Player.get_next_to_wall() == null:
		is_sliding = 0
		return STATES.FALL
		
	if Player.jump_input_actuation:
		if Input.is_action_pressed("MoveLeft") or Input.is_action_pressed("MoveRight"):
			is_sliding = 0
			return STATES.JUMP
	if Player.is_on_floor():
		return STATES.IDLE
	if Player.new_item_activate:
		$"../../AnimationPlayer".play("new_item")
		return STATES.NEWITEM
	if Player.dash_input and Player.can_dash:
		if Input.is_action_pressed("MoveLeft") or Input.is_action_pressed("MoveRight"):
			return STATES.DASH
	if Player.is_in_water:
		$"../../AnimationPlayer2".play("idle_swimming")
		return STATES.INWATER
	return null

func slide_movement(delta):
	is_sliding = 1
	if Player.climb_input:
		if Player.movement_input.y < 0:
			Player.velocity.y = -climb_speed
		elif Player.movement_input.y > 0:
			Player.velocity.y = climb_speed
			Player.movement_input.x = -300
			Player.velocity.x = -100
		#elif Input.is_action_pressed("Jump"):
		#	Player.velocity.y = Player.JUMP_VELOCITY
		else:
			Player.velocity.y = 0
	else:
		player_slidemove()
		#player_movement()
		Player.gravity(delta)
		#
		Player.velocity.y *= slide_friction


func player_slidemove():
	if Input.is_action_pressed("MoveRight") && Input.is_action_pressed("Jump"):
		Player.velocity.x = 500
		Player.velocity.y = Player.JUMP_VELOCITY * 1.5
	if Input.is_action_pressed("MoveLeft") && Input.is_action_pressed("Jump"):
		Player.velocity.x = 500
		Player.velocity.y = Player.JUMP_VELOCITY * 1.5
