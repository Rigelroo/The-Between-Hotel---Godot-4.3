extends CharacterBody2D

class_name EnemyVespa



@onready var hit_player = $Hit
@onready var animplayer = $Body2

@export_subgroup("Health & Damage")
@export var health = 5
@export var health_max = 5
@export var health_min = 0

@export var damage_value = 5
@export var damage_max = 5
@export var damage_min = 0



var dead: bool = false
var taking_damage : bool = false
var damage_to_deal = 20
var is_dealing_damage: bool = false
var is_enemy_chase : bool = false
var knockback_force = 100
var knockback_vector = Vector2.ZERO
var velox = Vector2.ZERO
var dir: Vector2
var is_roaming: bool = true
var gravity_value = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var collision = $"../../FollowArea/CollisionShape2D"
var player_exited: bool = false
var player_entered: bool = false

@export_subgroup("Movement")
@export var speed = 150
@export_enum("Stopped", "Chase", "One direction_x", "One direction_y", "Aleatory_x", "Aleatory_y", "Aleatory_z") var movement_type: int
@export_enum("No gravity", "Inverted", "Normal", "Stopped" ) var gravity_type: int
@export var gravity_strength : float = 1.0

var movement_type_const = null

var player : CharacterBody2D
@onready var STATES = $EnemyStateMachine

var current_state = null
var prev_state = null

func gravity_manager(delta):
	if gravity_type == 1:
		velocity.y += -gravity_value * delta * gravity_strength * 10
	if !is_on_floor():
		if gravity_type == 0:
			pass
		if gravity_type == 2:
			velocity.y += gravity_value * delta * gravity_strength * 10
		if gravity_type == 3:
			velocity.y = 0


func movement_manager(delta):
	if movement_type == 0:
		velocity = Vector2()
		
	elif movement_type == 1:
		var dir_to_player = position.direction_to(player.position) * speed
		velocity = dir_to_player
		dir.x = abs(velocity.x) / velocity.x
	elif movement_type == 2:
		one_dir_x()
		velocity += dir * speed * delta
		
	elif movement_type == 3:
		one_dir_y()
		velocity += dir * speed * delta 
	elif movement_type >= 4:
		velocity += dir * speed * delta

func choose(array):
	array.shuffle()
	return array.front()

func _on_directiontimer_timeout() -> void:
	$Directiontimer.wait_time = choose([0.5,1.5,2.0,2.5])
	if movement_type == 4:
		dir = choose([Vector2.RIGHT, Vector2.LEFT])
	if movement_type == 5:
		dir = choose([Vector2.UP, Vector2.DOWN])
	if movement_type == 6:
		var UPRIGHT = Vector2.UP + Vector2.RIGHT
		var UPLEFT = Vector2.UP + Vector2.LEFT
		var DOWNRIGHT = Vector2.DOWN + Vector2.RIGHT
		var DOWNLEFT = Vector2.DOWN + Vector2.LEFT
		
		dir = choose([Vector2.UP, Vector2.DOWN, Vector2.RIGHT, Vector2.LEFT, UPRIGHT, UPLEFT, DOWNRIGHT, DOWNLEFT])
		

func one_dir_x():
	var Raycasts = %Raycasts
	for raycast in Raycasts.get_children():
		raycast.force_raycast_update() 
		if raycast.is_colliding():
			if raycast == $Raycasts/Rightraycast:
				dir = Vector2.LEFT
			elif raycast == $Raycasts/Leftraycast:
				dir = Vector2.RIGHT

func one_dir_y():
	var Raycasts = %Raycasts
	for raycast in Raycasts.get_children():
		raycast.force_raycast_update() 
		if raycast.is_colliding():
			if raycast == $Raycasts/Upraycast:
				dir = Vector2.DOWN
			elif raycast == $Raycasts/Downraycast:
				dir = Vector2.UP

func _ready() -> void:
	movement_type_const = movement_type
	if movement_type == 2:
		dir = Vector2.RIGHT
		
	if movement_type == 3:
		dir = Vector2.UP
		$Raycasts/Upraycast.enabled = true
		$Raycasts/Downraycast.enabled = true
	print("movement_type: ", movement_type)
	for state in STATES.get_children():
		state.STATES = STATES
		state.Entity = self
	prev_state = STATES.IDLE
	current_state = STATES.IDLE

	
	player = get_tree().get_first_node_in_group("Player")
	%HPlabel.text = "HP: " + str(health)


func change_state(input_state):
	if input_state != null:
		prev_state = current_state 
		current_state = input_state
		
		prev_state.exit_state()
		current_state.enter_state()

func _on_damage_area_area_entered(area: Area2D) -> void:
	
	if (area == player.slashbox) or (area == player.slashbox_down):
		damage()
		damage_manager()
		%HPlabel.text = "HP: " + str(health)
	#if (area == player.slashbox_down):
		#damage()
		#damage_manager()
		#%HPlabel.text = "HP: " + str(health)

func damage_manager():
	if health <= health_min:
		await hit_player.animation_finished
		queue_free()
	else:
		take_damage()

func damage():
	is_dealing_damage = true
	hit_player.play("hit")
	await hit_player.animation_finished
	is_dealing_damage = false
	$Body2.play("Idle")
	print("hit")

#var knockback = Vector2.ZERO
var just_bool = false 

func _physics_process(delta):
	change_state(current_state.update(delta))
	%Statelabel.text = current_state.name
	movement_manager(delta)
	gravity_manager(delta)
	move_and_slide()
	
	if velocity.x > 0:
		just_bool = true
		$Sprite2D3.flip_h = just_bool 
		$Sprite2D.flip_h = just_bool 
		$Sprite2D2.flip_h = just_bool 
	else:
		just_bool = false
		$Sprite2D3.flip_h = just_bool 
		$Sprite2D.flip_h = just_bool 
		$Sprite2D2.flip_h = just_bool 
	if knockback_vector != Vector2.ZERO:
		velocity = knockback_vector


var can_return : bool = false


func take_damage():
	health -= 1
	
	var knockback = 3 if (player.global_position.x - self.global_position.x) > 0 else -1
	knockback_force *= knockback
	velocity.x = knockback
	

func _on_follow_area_body_exited(body: Node2D) -> void:
	if (body == player):
		player_exited = true
		print("saiu")


func _on_follow_area_body_entered(body: Node2D) -> void:
	if (body == player):
		player_entered = true
		print("entrô")
