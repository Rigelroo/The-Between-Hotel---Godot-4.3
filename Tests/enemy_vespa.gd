extends CharacterBody2D

class_name EnemyVespa

var speed = 300

@onready var hit_player = $Hit
@onready var animplayer = $Body2

var health = 5
var health_max = 5
var health_min = 0

var dead: bool = false
var taking_damage : bool = false
var damage_to_deal = 20
var is_dealing_damage: bool = false

var knockback_force = 100
var knockback_vector = Vector2.ZERO
var velox = Vector2.ZERO
@export var a : bool

var player : CharacterBody2D
@onready var STATES = $EnemyStateMachine

var current_state = null
var prev_state = null

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	%HPlabel.text = "HP: " + str(health)
	for state in STATES.get_children():
		state.STATES = STATES
		state.Player = self
	prev_state = STATES.IDLE
	current_state = STATES.IDLE

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

func _physics_process(delta: float) -> void:
	%Statelabel.text = str(current_state.get_name())
	move_and_slide()
	var just_bool = false 
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

func take_damage():
	health -= 1
	
	var knockback = 3 if (player.global_position.x - self.global_position.x) > 0 else -1
	knockback_force *= knockback
	velocity.x = knockback
	#if knockback_force != Vector2.ZERO:
		#knockback_vector = knockback_force
		#
		#var knockback_tween := get_tree().create_tween()
		#knockback_tween.tween_property(self, "knockback_vector", Vector2.ZERO, duration) 

func play_knockback():
	pass
	#var direction = global_position.direction_to(player.global_position)
	#var force = direction * knockback_force
	#velocity = (direction * speed * 3 + knockback * 20)
	#$KnockbackTimer.start(0.7)
	#await $KnockbackTimer.timeout
	#velocity -= velocity
