extends "res://scenes/entities/Enemies/stateenemy.gd"

# Called when the node enters the scene tree for the first time.

func update(delta):
	Entity.movement_manager(delta)
	stop_following()
	if Entity.player_exited:
		return STATES.IDLE
	return null

func enter_state():
	Entity.movement_type = 1
	Entity.player_entered = false

func stop_following():
	var distance = player.position - Entity.global_position
	
	if distance.length() < 230:
		Entity.movement_type = 0
	if distance.length() > 230:
		Entity.movement_type = 1
#extends EnemyState
#
#
#@onready var collision = $"../../FollowArea/CollisionShape2D"
#var player_exited: bool = false
#
#func enter_state():
	#super.enter_state()
	#owner.set_physics_process(true)
	#animation_body.play("Idle")
	#print("u")
	#
#
#func exit_state():
	#super.exit_state()
	#owner.set_physics_process(false)
#
#func transition():
	#var distance = player.global_position - owner.global_position
	##var distance = owner.direction.lenght()
	#if get_parent().previous_state.name == "EnemyAttack":
		#get_parent().change_state("EnemyAwait")
	#if !get_parent().previous_state.name == "EnemyAttack":
		#if distance.length() < 190:
			#owner.velocity = Vector2()
			#get_parent().change_state("EnemyAttack")
#
##var player_entered: bool = false:
	##set(value):
		##player_entered = value
		##collision.set_deferred("disabled", value)
### Called when the node enters the scene tree for the first time.
##
##func transition():
	##if !player_entered:
		##get_parent().change_state("EnemyIdle")
		##
##
##func _on_follow_area_body_exited(body: Node2D) -> void:
	##if (body == player):
		##player_entered = false
#
#
#
#
#func _on_follow_area_body_exited(body: Node2D) -> void:
	#if (body == player):
		#player_exited = true
