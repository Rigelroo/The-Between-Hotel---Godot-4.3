extends CharacterBody2D

@onready var animplayer = $Body2
@onready var dropmarker: Marker2D = $Dropmarker
@onready var damage_numbers_origin = %DamagenumOrigin
@onready var hit_player = $Hit
@export_enum("loop","linear") var patrol_type = "linear"
@export var path : PathFollow2D

const coin_instance = preload("res://inventory/Moedas/coin.tscn")
@onready var player = get_tree().get_first_node_in_group("Player")
@export var coin_amount: int = 1
@export var crit_chance: float = 0.3

@onready var STATES = $EnemyStateMachine
var current_state = null
var prev_state = null

var damage_value = 1

@export var speed : float = 120.0
var gravity_value = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta: float) -> void:
	%Statelabel.text = str(current_state.get_name())
	change_state(current_state.update(delta))
	move_and_slide()



func _ready() -> void:
	for state in STATES.get_children():
		state.STATES = STATES
		state.Entity = self
		state.player = player
	prev_state = STATES.IDLE
	current_state = STATES.IDLE
	

func change_state(input_state):
	if input_state != null:
		prev_state = current_state 
		current_state = input_state
		
		prev_state.exit_state()
		current_state.enter_state()

func take_damage(amount: int, is_critical: bool):
	Damagenumbers.display_number(amount, damage_numbers_origin.global_position, false)
	hit_player.play("hit")
	


func die():
	
	create_coin()

func create_coin():
	for i in range(coin_amount):
		var coin = coin_instance.instantiate()
		
		get_parent().call_deferred("add_child", coin)
		coin.global_position = dropmarker.global_position
		coin.apply_impulse(Vector2(randi_range(-300, 300), -250))



func _on_damage_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("attackbox"):
		if area.owner.has_method("player"):
			deal_damage(area.owner.damage_component.damage_value, area)


func deal_damage(value: int, area: Area2D):
	var damage = critical(area, value)
	take_damage(damage[0], damage[1])

func critical(area, value):
	var is_critical = area.owner.damage_component.crit_chance > randf()
	if is_critical:
		var damage_total = value * 2
		return [damage_total, true]
	else:
		return [value, false]
