extends Node

class_name EnemyState


@onready var animation_hit = %Hit

@onready var statedebug = %Statelabel

signal Transitioned
var player = null
var STATES = null
var Entity = null


func enter_state():
	pass

func exit_state():
	pass
	
func update(delta):
	return null
