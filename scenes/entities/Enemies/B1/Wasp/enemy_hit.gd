extends EnemyState



	#set(value):
		#player_entered = value
		#collision.set_deferred("disabled", value)
# Called when the node enters the scene tree for the first time.

func update(delta):
	Entity.movement_manager(delta)
	if !Entity.is_dealing_damage:
		return STATES.FOLLOW
	if Entity.health <= Entity.health_min:
		return STATES.DEFEAT
		
	
	return null

func enter_state():
	Entity.can_flip = false
	%Hit.play("hit")
	Entity.movement_type = 7
	Entity.speed = 300
	
func exit_state():
	Entity.speed = 150
	Entity.movement_type = 0
	Entity.can_flip = true
