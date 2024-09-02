extends EnemyState



	#set(value):
		#player_entered = value
		#collision.set_deferred("disabled", value)
# Called when the node enters the scene tree for the first time.

func update(delta):
	Entity.movement_manager(delta)
	var distance = player.position - Entity.global_position
	var distancex = player.position.x - Entity.global_position.x
	if distance.length() < 430:
		return STATES.CLOSE
	if Entity.health <= Entity.health_min:
		return STATES.DEFEAT

	return null

func enter_state():
	$"../../CollisionShape2D".disabled = true
	%Damagebox.disabled = true
	if Entity.prev_state == STATES.CLOSE:
		await %Body.animation_finished
		%Body.play("inactive")
	elif Entity.prev_state == STATES.ACTIVE:
		%Body.play("out")
		await %Body.animation_finished
		%Body.play("inactive")
		
	Entity.movement_type = Entity.movement_type_const
	Entity.player_exited = false
