extends EnemyState

# Called when the node enters the scene tree for the first time.
var is_attacking = false

func update(delta):
	Entity.movement_manager(delta)
	stop_following()
	if Entity.player_exited:
		return STATES.IDLE
	if !is_attacking:
		return STATES.PREPARE
	var distance = player.position - Entity.global_position

	if distance.length() > 230:
		return STATES.FOLLOW
		
	#if Entity.health <= Entity.health_min:
		#return STATES.DEAD
	if Entity.is_dealing_damage:
		return STATES.HIT
	if Entity.health <= Entity.health_min:
		return STATES.DEFEAT
	return null
func exit_state():
	Entity.speed = 150

func enter_state():
	Entity.can_flip = true
	%Body2.play("attack")
	Entity.speed = 300
	Entity.position_saver = Entity.global_position
	is_attacking = true
	Entity.movement_type = 1
	Entity.player_entered = false

func stop_following():
	var distance = player.position - Entity.global_position
	if distance.length() < 190:
		Entity.movement_type = 0
	if distance.length() > 230:
		Entity.movement_type = 1
		

func stop_attack():
	Entity.can_attack = false
	is_attacking = false

#extends EnemyState
#
#signal attackfinished
#
#@export var move_speed : float = 15000
#
#var dir: Vector2
#
#func enter_state():
	#super.enter_state()
	#owner.set_physics_process(true)
	#attack_movement()
	#animation_body.play("attack")
	#
	#
#
#
#
#func transition():
	#var distance = player.global_position - owner.global_position
	##if owner.direction.lenght() > 250:
	#if distance.length() > 250:
		#get_parent().change_state("EnemyIdle")
	#
#
#
#func attack_movement():
	#var dir_to_player = owner.global_position.direction_to(player.position) * move_speed
	#owner.velocity = dir_to_player
	#dir.x = abs(owner.velocity.x) / owner.velocity.x
#
#
#
#func attack_movement1():
	#var distance = player.global_position - owner.global_position
	##var distance = owner.direction.lenght()
	#if distance.length() < 1:
		#owner.velocity = Vector2()
#
#func attack_movement2():
	#var direction = player.global_position - owner.global_position
	#owner.velocity = direction.normalized() * move_speed
#
#
#func _on_body_2_animation_finished(anim_name: StringName = "attack") -> void:
	##animation_body.play("attack_return")
	#attackfinished.emit(get_parent().change_state("EnemyAwait"))
