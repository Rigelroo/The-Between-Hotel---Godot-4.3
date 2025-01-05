extends "state.gd"


#@export_custom(PROPERTY_HINT_MAX, "a", 6) var pas: int

func update(delta):
	# Desacelera gradualmente
	Player.velocity.x = move_toward(Player.velocity.x, 0, Player.slide_deceleration * delta)

	# Sai do estado de derrapagem quando a velocidade é quase zero
	if abs(Player.velocity.x) < 10:
		Player.velocity.x = 0
		return STATES.IDLE

	return null

func enter_state():
	pass

func play_turn_animation():
	# Reproduz a animação de troca de direção, caso exista
	if owner.has_node("%AnimationPlayer"):
		var anim_player = get_node("%AnimationPlayer")
		if anim_player.has_animation("turn"):
			anim_player.play("turn")
			await anim_player.animation_finished
			anim_player.play("run")


#var slide_deceleration = 200
#var is_sliding = false
#
#func update(delta):
	#if is_sliding:
		#Player.velocity.x = move_toward(Player.velocity.x, 0, slide_deceleration * delta)
		#
		#if abs(Player.velocity.x) < 20:
			#is_sliding = false
			#Player.current_state = STATES.IDLE
			#return STATES.IDLE
		#elif Player.movement_input.x != 0:
			#is_sliding = false
			#Player.current_state = STATES.MOVE
			#return STATES.MOVE
		#elif Player.jump_input_actuation:
			#is_sliding = false
			#Player.current_state = STATES.JUMP
			#return STATES.JUMP
#
	#return null
#
#func enter_state():
	#is_sliding = true
	#Player.current_state = STATES.SLIDEH
	#Player.velocity.x *= 0.5
	#%AnimationPlayer.play("changeside")
#
#func start_sliding():
	#is_sliding = true
	#%AnimationPlayer.play("changeside")
#
#func exit_state():
	#is_sliding = false
	#Player.velocity.x = 0 
	#%AnimationPlayer.stop()
#


	#if Player.velocity.x == 0:
		#
		#return STATES.IDLE
	#if Player.velocity.y >0:
		#return STATES.FALL
	#if Player.jump_input_actuation:
		#if !Player.is_in_water:
			#return STATES.JUMP
	#if Player.dash_input and Player.can_dash:
		#return STATES.DASH
	#if Player.attack_input && !Player.can_interact:
		#return STATES.SLASH
	#if Player.new_item_activate:
		#$"../../AnimationPlayer".play("new_item")
		#return STATES.NEWITEM
	#if Player.dying:
		#$"../../AnimationPlayer".play("Defeat")
		#return STATES.DEATH
	#if Player.is_in_water:
		#$"../../AnimationPlayer2".play("idle_swimming")
		#return STATES.INWATER
	#if Player.is_dealing_damage == true:
		#return STATES.HIT
