extends Node2D

@onready var Entity = $".."
var player = null

@export_enum("No gravity", "Inverted", "Normal", "Stopped" ) var gravity_type: String
@export var gravity_strength: float = 1.0
@export_enum("Stopped", "Chase", "One direction_x", "One direction_y", "Aleatory_x", "Aleatory_y", "Aleatory_z", "Runaway", "Path") var movement_type: String



func enemy_movement(delta):
	
	match movement_type:
		"Stopped":  # Movimento parado
			Entity.velocity = Vector2.ZERO

		"Chase":  # Persegue o jogador
			if player:
				var dir_to_player = Entity.global_position.direction_to(player.global_position)
				Entity.velocity = dir_to_player * Entity.speed

		"One direction_x":  # Move-se em uma direção fixa no eixo X
			Vector2.RIGHT * Entity.speed
			if Entity.velocity == Vector2.ZERO:
				Entity.velocity = Vector2.RIGHT * Entity.speed
			var raycasts = %Raycasts
			for raycast in raycasts.get_children():
				raycast.force_raycast_update()
				if raycast.is_colliding():
					Entity.velocity.x = -Entity.velocity.x  # Inverte a direção

		"One direction_y":  # Move-se em uma direção fixa no eixo Y
			if Entity.velocity == Vector2.ZERO:
				Entity.velocity = Vector2.DOWN * Entity.speed
			var raycasts = %Raycasts
			for raycast in raycasts.get_children():
				raycast.force_raycast_update()
				if raycast.is_colliding():
					Entity.velocity.y = -Entity.velocity.y  # Inverte a direção

		"Aleatory_x":  # Movimento aleatório no eixo X
			Entity.velocity.x += randi_range(-1, 1) * Entity.speed * delta

		"Aleatory_y":  # Movimento aleatório no eixo Y
			Entity.velocity.y += randi_range(-1, 1) * Entity.speed * delta

		"Aleatory_z":  # Movimento aleatório nos eixos X e Y
			Entity.velocity.x += randi_range(-1, 1) * Entity.speed * delta
			Entity.velocity.y += randi_range(-1, 1) * Entity.speed * delta

		"Runaway":  # Foge do jogador
			if player:
				var dir_from_player = Entity.global_position.direction_to(player.global_position) * -1
				Entity.velocity = dir_from_player * Entity.speed

		"Path":  # Segue um Path2D, se disponível
			if Entity.path:
				followPath()
				if Entity.path.progress_ratio > 0:
					var offset = Entity.path.progress
					offset += Entity.speed * delta
					Entity.path.progress = offset
					Entity.global_position = Entity.path.get_parent().curve.sample_baked(offset)
				if Entity.path.progress_ratio == 1:
					Entity.path.progress_ratio = 0
				else:
					Entity.path.progress_ratio = 1
				#var offset = Entity.path.offset
				#offset += Entity.speed * delta
				#Entity.path.offset = offset
				#Entity.global_position = Entity.path.curve.interpolate_baked(offset)
	
	
		_:  # Caso padrão (fallback)
			Entity.velocity = Vector2.ZERO

var progress = 1
var duration = 2

func followPath():
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(Entity.path, "progress_ratio", progress, duration)
	await get_tree().create_timer(duration).timeout
	print(Entity.path.progress_ratio)
	if progress == 1:
		progress = 0
	else:
		progress = 1
	
	followPath()

func gravity(delta):
	var grav
	if Entity.is_on_floor():
		return 0.0
	if !Entity.is_on_floor():
		match gravity_type:
			"No gravity":  # Sem gravidade
				grav = 0

			"Inverted":  # Gravidade invertida (para cima)
				grav = Entity.gravity_value * gravity_strength * delta

			"Normal":  # Gravidade normal (para baixo)
				grav = Entity.gravity_value * gravity_strength * delta

			"Stopped":  # Gravidade parada
				grav = 0
		return grav
