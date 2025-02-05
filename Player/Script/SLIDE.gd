extends "state.gd"

@onready var raycasts: Node2D = $"../../Raycasts"

@export var climb_speed = 50
@export var slide_friction = .9
@export var is_sliding = false

var can_wall_jump = true  # Controle para evitar wall climbing
var wall_direction = Vector2.ZERO  # Direção da parede

func update(delta):
	slide_movement(delta)
	# Verifica se o player está próximo da parede e fora do chão
	if not Player.is_on_floor() and Player.get_next_to_wall():
		var next_to_wall = Player.get_next_to_wall()
		
		# Entra no estado de deslizar se a direção está pressionada e condiz com a parede
		#if not is_sliding and (
			#(next_to_wall == Vector2.RIGHT and Input.is_action_pressed("MoveRight")) or
			#(next_to_wall == Vector2.LEFT and Input.is_action_pressed("MoveLeft"))
		#):
			#enter_state()
			#return STATES.SLIDE

	# Sai do estado de deslizar se não está mais segurando a direção ou saiu da parede
	if is_sliding:
		if not Input.is_action_pressed("MoveLeft") and not Input.is_action_pressed("MoveRight"):
			exit_slide_state()
			return STATES.FALL
		if not Player.get_next_to_wall():
			exit_slide_state()
			return STATES.FALL

	# Executa o pulo para trás caso o botão de pulo seja pressionado
	if is_sliding and Input.is_action_just_pressed("Jump") and can_wall_jump:
		exit_slide_state()
		
		return STATES.JUMP

	# Volta ao estado idle ao tocar o chão
	if Player.is_on_floor():
		exit_slide_state()
		return STATES.IDLE
	
	return null


func enter_state():
	%FrictionParticles.process_material = load("res://Diversos/wallslide_particle.tres")
	%FrictionParticles.emitting = true
	slide_friction = .9
	Player.velocity.y = 0
	print("is sliding!")
	is_sliding = true
	wall_direction = Player.get_next_to_wall()
	# Ajuste da posição para evitar tremores
	if wall_direction == Vector2.RIGHT:
		if raycasts.buttom_right.is_colliding():
			Player.position.x -= 3.0
			%Sprite2D.position = Vector2(-27.0, -101)
	elif wall_direction == Vector2.LEFT:
		if raycasts.buttom_left.is_colliding():
			Player.position.x += 3.0
			%Sprite2D.position = Vector2(46.0, -101)
	
	$"../../AnimationPlayer".play("slide") 
func exit_slide_state():
	is_sliding = false
	$"../../AnimationPlayer".stop()
func exit_state():
	slide_friction = .9
	%FrictionParticles.process_material = load("res://Diversos/walk_particle.tres")
	%FrictionParticles.emitting = false
	%Sprite2D.position = Vector2(13, -101)

func wall_jump():
	if wall_direction == Vector2.RIGHT:
		Player.velocity = Vector2(-800, -Player.JUMP_VELOCITY)
		
	elif wall_direction == Vector2.LEFT:
		
		Player.velocity = Vector2(800, -Player.JUMP_VELOCITY)
	Player.velocity.y = Player.JUMP_VELOCITY
	# Impede o wall climbing
	can_wall_jump = false
	await get_tree().create_timer(0.2).timeout
	can_wall_jump = true

func slide_movement(delta):
	if is_sliding:
		Player.velocity.y += Player.gravity(delta)
		var v = Player.gravity(delta)
		Player.velocity.y *= slide_friction
		#Player.velocity.y += Player.gravity(delta * slide_friction)
		var v2 = Player.velocity.y
		pass
