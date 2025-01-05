extends Node

var STATES = null
var Player = null

# Métodos de ciclo de vida do estado
func enter_state():
	pass

func exit_state():
	pass

func update(delta):
	return null
func player_movement(delta):
	# Impedir derrapagem em certos estados (caindo, pulando, etc.)
	if Player.current_state in [STATES.JUMP, STATES.FALL, STATES.DASH, STATES.SLASH, STATES.HIT]:
		# Manter velocidade sem aplicar derrapagem
		if Player.movement_input.x != 0:
			Player.velocity.x = lerp(Player.velocity.x, Player.movement_input.x * Player.SPEED, 10 * delta)
			Player.last_direction = Vector2.RIGHT if Player.movement_input.x > 0 else Vector2.LEFT
		return  # Sai da função para evitar derrapagem

	# Mudança brusca para a direita
	if Player.movement_input.x > 0 and Player.velocity.x < 0:
		Player.velocity.x = move_toward(Player.velocity.x, Player.movement_input.x * Player.SPEED, Player.slide_deceleration * delta)
		STATES.SLIDEH.play_turn_animation()  # Chama a animação de troca de direção

	# Mudança brusca para a esquerda
	elif Player.movement_input.x < 0 and Player.velocity.x > 0:
		Player.velocity.x = move_toward(Player.velocity.x, Player.movement_input.x * Player.SPEED, Player.slide_deceleration * delta)
		STATES.SLIDEH.play_turn_animation()  # Chama a animação de troca de direção

	# Movimento normal na mesma direção
	elif Player.movement_input.x != 0:
		Player.velocity.x = lerp(Player.velocity.x, Player.movement_input.x * Player.SPEED, 10 * delta)
		Player.last_direction = Vector2.RIGHT if Player.movement_input.x > 0 else Vector2.LEFT

	# Soltou o botão
	elif abs(Player.velocity.x) > 0:
		Player.velocity.x = move_toward(Player.velocity.x, 0, Player.slide_deceleration * delta)

	# Certifique-se de zerar a velocidade
	else:
		Player.velocity.x = 0



#func player_movement(delta):
	## Se o jogador está se movendo
	#if Player.movement_input.x != 0:
		#Player.velocity.x = lerp(Player.velocity.x, Player.movement_input.x * Player.SPEED, 10 * delta)
		#Player.last_direction = Vector2.RIGHT if Player.movement_input.x > 0 else Vector2.LEFT
#
	## Soltou o botão, inicia derrapagem
	#elif abs(Player.velocity.x) > 0:
		## Desacelera gradualmente
		#Player.velocity.x = move_toward(Player.velocity.x, 0, STATES.SLIDEH.slide_deceleration * delta)
#
	## Certifique-se de zerar a velocidade
	#else:
		#Player.velocity.x = 0

#func player_movement(delta):
	#if not STATES.SLIDEH.is_sliding:
		#if Player.movement_input.x > 0: 
			#if Player.velocity.x < 0:
				#STATES.SLIDEH.start_sliding()
			#else:
				## Ajusta a velocidade para a direita
				#Player.velocity.x = lerp(Player.velocity.x, Player.SPEED, 10 * delta)
			#Player.last_direction = Vector2.RIGHT
#
		#elif Player.movement_input.x < 0:  # Movendo para a esquerda
			#if Player.velocity.x > 0:
				## Mudança de direção brusca para a esquerda
				#STATES.SLIDEH.start_sliding()
			#else:
				## Ajusta a velocidade para a esquerda
				#Player.velocity.x = lerp(Player.velocity.x, -Player.SPEED, 10 * delta)
			#Player.last_direction = Vector2.LEFT
#
		#else:
			## Soltou o botão, inicia derrapagem se houver velocidade
			#if abs(Player.velocity.x) > 0:
				#STATES.MOVE.start_sliding()
	#else:
		## Se estiver no estado SLIDEH, desacelera gradualmente
		#Player.velocity.x = move_toward(Player.velocity.x, 0, STATES.SLIDEH.slide_deceleration * delta)
#
		#if abs(Player.velocity.x) < 30:
			#Player.velocity.x = 0
			#STATES.SLIDEH.is_sliding = false

#extends Node
#
#
#var STATES = null
#var Player = null
#
#func enter_state():
	#pass
#func exit_state():
	#pass
#func update(_delta):
	#return null
##func player_movement():
	##if Player.movement_input.x >0:
		##Player.velocity.x = Player.SPEED
		##Player.last_direction = Vector2.RIGHT
	##elif Player.movement_input.x <0:
		##Player.velocity.x = - Player.SPEED
		##Player.last_direction = Vector2.LEFT
	##else:
		##Player.velocity.x = 0
#
#var moveright = false
#var moveleft = false
##
##func player_movement():
	##
	### Evitar alterar velocity.x enquanto deslizando
	##if not STATES.SLIDE.is_sliding:
		##if Player.movement_input.x > 0:
##
			##Player.velocity.x = Player.SPEED
			##Player.last_direction = Vector2.RIGHT
		##elif Player.movement_input.x < 0:
			##Player.velocity.x = -Player.SPEED
			##Player.last_direction = Vector2.LEFT
		##else:
			##Player.velocity.x = 0
#
#
#
#func player_movement(delta):
	## Se o jogador estiver se movendo
	#if not STATES.SLIDEH.is_sliding:
		#if Player.movement_input.x > 0:
			#if Player.velocity.x < 0:
				## Mudança de direção brusca
				#STATES.SLIDEH.start_sliding()
			#else:
				#Player.velocity.x = lerp(Player.velocity.x, Player.SPEED, 10 * delta)
			#Player.last_direction = Vector2.RIGHT
		#elif Player.movement_input.x < 0:
			#if Player.velocity.x > 0:
				## Mudança de direção brusca
				#STATES.SLIDEH.en
			#else:
				#Player.velocity.x = lerp(Player.velocity.x, -Player.SPEED, 10 * delta)
			#Player.last_direction = Vector2.LEFT
		#else:
			## Soltou o botão, começa a derrapagem
			#if Player.velocity.x != 0:
				#STATES.SLIDEH.start_sliding()
	#else:
		## Reduz gradualmente a velocidade durante a derrapagem
		#Player.velocity.x = move_toward(Player.velocity.x, 0, STATES.SLIDEH.slide_deceleration * delta)
		#if abs(Player.velocity.x) < 10:
			#Player.velocity.x = 0
			#STATES.SLIDEH.is_sliding = false
