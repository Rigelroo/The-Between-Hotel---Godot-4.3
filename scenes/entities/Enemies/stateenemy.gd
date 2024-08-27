extends Node

class_name EnemyState

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var animation_hit = $Hit
@onready var animation_body = %Body2
@onready var statedebug = %Statelabel

signal Transitioned

var STATES = null
var Player = null
func _ready():
	set_physics_process(false)

func enter_state():
	set_physics_process(true)

func exit_state():
	set_physics_process(false)
	
func transition():
	pass

func _physics_process(_delta: float):
	statedebug.text = name
	transition()
	

func update(delta):
	return null
func enemy_movement():
	pass
