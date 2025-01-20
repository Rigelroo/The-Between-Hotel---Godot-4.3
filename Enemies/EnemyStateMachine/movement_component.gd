extends EnemyBase
var movement_functions: Dictionary = {}

func _ready():
	position_saver = global_position
	movement_type_const = movement_type

	# Inicializar os métodos para cada movimento
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

func movement_manager(delta):
	if movement_type in movement_functions:
		movement_functions[movement_type].call

# Métodos específicos para cada tipo de movimento

func movement_stopped(delta):
	velocity = Vector2()

func movement_chase_player(delta):
	var dir_to_player = position.direction_to(SignalManager.player.position) * speed
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
	var dir_away = position.direction_to(SignalManager.player.position) * -1
	velocity += dir_away * speed * delta

# Métodos auxiliares para movimentos em uma direção com raycasts

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
