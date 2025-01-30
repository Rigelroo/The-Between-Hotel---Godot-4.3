extends Node

var STATES = null
var Player = null

func enter_state():
	Player.inout_label.text = "in" + str(Player.current_state.name)

func exit_state():
	Player.inout_label.text = "out" + str(Player.current_state.name)

func update(delta):
	return null

func player_movement(delta):
	if Player.current_state in [STATES.JUMP, STATES.FALL, STATES.SLASH, STATES.HIT]:
		if Player.movement_input.x != 0:
			if !Player.sprint_input:
				Player.velocity.x = lerp(Player.velocity.x, Player.movement_input.x * Player.SPEED, 10 * delta)
			else:
				Player.velocity.x = lerp(Player.velocity.x, Player.movement_input.x * Player.SPRINT_SPEED, 10 * delta)
			Player.last_direction = Vector2.RIGHT if Player.movement_input.x > 0 else Vector2.LEFT
		return 

	if Player.movement_input.x > 0 and Player.velocity.x < 0:
		Player.velocity.x = move_toward(Player.velocity.x, Player.movement_input.x * Player.SPEED, Player.slide_deceleration * delta)
		STATES.SLIDEH.play_turn_animation()

	elif Player.movement_input.x < 0 and Player.velocity.x > 0:
		Player.velocity.x = move_toward(Player.velocity.x, Player.movement_input.x * Player.SPEED, Player.slide_deceleration * delta)
		STATES.SLIDEH.play_turn_animation()

	elif Player.movement_input.x != 0:
		if !Player.sprint_input:
			Player.velocity.x = lerp(Player.velocity.x, Player.movement_input.x * Player.SPEED, 10 * delta)
		else:
			Player.velocity.x = lerp(Player.velocity.x, Player.movement_input.x * Player.SPRINT_SPEED, 10 * delta)
		Player.last_direction = Vector2.RIGHT if Player.movement_input.x > 0 else Vector2.LEFT

	elif abs(Player.velocity.x) > 0:
		Player.velocity.x = move_toward(Player.velocity.x, 0, Player.slide_deceleration * delta)

	else:
		Player.velocity.x = 0
