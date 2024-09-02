extends EnemyState

# Called when the node enters the scene tree for the first time.

func update(delta):
	Entity.movement_manager(delta)
	stop_following()
	if Entity.player_exited:
		if !Entity.is_dealing_damage:
			return STATES.IDLE
	if Entity.movement_type == 0 && Entity.can_attack:
		if !Entity.is_dealing_damage:
			return STATES.ATTACK
	if Entity.is_dealing_damage:
		return STATES.HIT
	if Entity.health <= Entity.health_min:
		return STATES.DEFEAT
	return null

func enter_state():
	%Body2.play("Idle")
	if Entity.prev_state != STATES.PREPARE:
		Entity.can_attack = true
	Entity.movement_type = 1
	print(Entity.movement_type)
	Entity.player_entered = false



func stop_following():
	var distance = player.position - Entity.global_position
	var distancex = player.position.x - Entity.global_position.x
	if distance.length() < 230:
		Entity.movement_type = 0
	if distancex < 250:
		Entity.movement_type = 0
	if distancex > 250:
		Entity.movement_type = 1
	
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
