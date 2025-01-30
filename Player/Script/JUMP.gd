extends "state.gd"

var wall_jump = false

func update(delta):
	Player.velocity.y += Player.gravity(delta)

	if !Player.prev_state == STATES.SLIDE:
		player_movement(delta)
	
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
		$"../../AnimationPlayer".play("jump_slide")
		wall_jump = true
		STATES.SLIDE.wall_jump()
		print("wall jump!")
		##Player.velocity.x = 1500#Player.movement_input = 1
		#Player.velocity.y = Player.JUMP_VELOCITY
		#Player.is_jumping = true
		#$"../../AnimationPlayer".play("jump_slide")
	else:
		print("comum jump!")
		Player.velocity.y = Player.JUMP_VELOCITY
		Player.is_jumping = true
		$"../../AnimationPlayer".play("jump_start")
		await $"../../AnimationPlayer".animation_finished
		$"../../AnimationPlayer".play("jump")

func exit_state():
	wall_jump = false
	print(Player.prev_state.name)
