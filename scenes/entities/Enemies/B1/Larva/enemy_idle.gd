extends EnemyState



	#set(value):
		#player_entered = value
		#collision.set_deferred("disabled", value)
# Called when the node enters the scene tree for the first time.

func update(delta):
	Entity.movement_manager(delta)
	if Entity.player_entered:
		if !Entity.is_dealing_damage:
			return STATES.FOLLOW
	if Entity.is_dealing_damage:
		return STATES.HIT
	return null

func enter_state():
	%Body2.play("Idle")
	Entity.movement_type = Entity.movement_type_const
	Entity.player_exited = false
