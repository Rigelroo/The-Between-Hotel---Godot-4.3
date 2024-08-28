extends "res://scenes/entities/Enemies/stateenemy.gd"



	#set(value):
		#player_entered = value
		#collision.set_deferred("disabled", value)
# Called when the node enters the scene tree for the first time.

func update(delta):
	Entity.movement_manager(delta)
	if Entity.player_entered:
		return STATES.FOLLOW
	return null

func enter_state():
	Entity.movement_type = Entity.movement_type_const
	Entity.player_exited = false
