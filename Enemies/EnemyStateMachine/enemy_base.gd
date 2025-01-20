
extends CharacterBody2D

class_name EnemyBase

# Atributos Gerais do Inimigo
@export var health: int = 5
@export var damage_value: int = 5
@export var speed: float = 150
@export_enum("No gravity", "Inverted", "Normal", "Stopped" ) var gravity_type: int
@export var gravity_strength: float = 1.0
@export_enum("Stopped", "Chase", "One direction_x", "One direction_y", "Aleatory_x", "Aleatory_y", "Aleatory_z", "Runaway", "Path") var movement_type: int


var dir: Vector2 = Vector2.ZERO
var dead: bool = false
var taking_damage: bool = false

# Jogador e controle de movimento
@onready var player = get_tree().get_first_node_in_group("Player")
var movement_functions: Dictionary = {}

func _ready():
	setup()
	initialize_movement_functions()

func setup():
	# Configuração inicial do inimigo (pode ser sobrescrito)
	dir = Vector2.ZERO

func initialize_movement_functions():
	movement_functions = {
		0: movement_stopped,
		1: movement_chase_player,
		2: movement_one_direction_x,
		3: movement_one_direction_y,
		4: movement_aleatory_x,
		5: movement_aleatory_y,
		6: movement_aleatory_z,
		7: movement_runaway_player,
	}
	if movement_type in [2, 3]:
		initialize_one_direction_movement()

func _physics_process(delta):
	if not dead:
		apply_gravity(delta)
		movement_manager(delta)
		move_and_slide()

func apply_gravity(delta):
	if gravity_type == 1:  # Inverted gravity
		velocity.y += -ProjectSettings.get_setting("physics/2d/default_gravity") * delta * gravity_strength
	elif gravity_type == 2:  # Normal gravity
		velocity.y += ProjectSettings.get_setting("physics/2d/default_gravity") * delta * gravity_strength

func movement_manager(delta):
	if movement_type in movement_functions:
		movement_functions[movement_type].call(delta)

# Métodos Específicos de Movimentos
func movement_stopped(delta):
	velocity = Vector2()

func movement_chase_player(delta):
	var dir_to_player = position.direction_to(player.position) * speed
	velocity = dir_to_player
	dir.x = sign(velocity.x)  # Atualiza direção

func movement_one_direction_x(delta):
	one_dir_x()
	velocity += dir * speed * delta

func movement_one_direction_y(delta):
	one_dir_y()
	velocity += dir * speed * delta

func movement_aleatory_x(delta):
	velocity += dir * speed * delta

func movement_aleatory_y(delta):
	velocity += dir * speed * delta

func movement_aleatory_z(delta):
	velocity += dir * speed * delta

func movement_runaway_player(delta):
	var dir_away = position.direction_to(player.position) * -1
	velocity += dir_away * speed * delta

# Métodos Auxiliares
func one_dir_x():
	var raycasts = %Raycasts
	for raycast in raycasts.get_children():
		raycast.force_raycast_update()
		if raycast.is_colliding():
			if raycast == $Raycasts/Rightraycast:
				dir = Vector2.LEFT
			elif raycast == $Raycasts/Leftraycast:
				dir = Vector2.RIGHT

func one_dir_y():
	var raycasts = %Raycasts
	for raycast in raycasts.get_children():
		raycast.force_raycast_update()
		if raycast.is_colliding():
			if raycast == $Raycasts/Upraycast:
				dir = Vector2.DOWN
			elif raycast == $Raycasts/Downraycast:
				dir = Vector2.UP

func initialize_one_direction_movement():
	if movement_type == 2:
		dir = Vector2.RIGHT
	elif movement_type == 3:
		dir = Vector2.UP
		$Raycasts/Upraycast.enabled = true
		$Raycasts/Downraycast.enabled = true

func take_damage(amount: int, is_critical: bool):
	health -= amount
	if health <= 0:
		die()

func die():
	dead = true
	queue_free()
