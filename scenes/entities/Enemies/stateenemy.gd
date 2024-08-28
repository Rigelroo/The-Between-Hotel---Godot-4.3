extends Node

class_name EnemyState

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var animation_hit = %Hit
@onready var animation_body = %Body2
@onready var statedebug = %Statelabel

signal Transitioned

var STATES = null
var Entity = null


func enter_state():
	pass

func exit_state():
	pass
	
func update(delta):
	return null


func enemy_movement():
	pass
