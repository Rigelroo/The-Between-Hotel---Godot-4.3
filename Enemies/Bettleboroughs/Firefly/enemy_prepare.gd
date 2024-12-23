extends EnemyState

# Called when the node enters the scene tree for the first time.

func update(delta):
	Entity.movement_manager(delta)
	
	stop_following()
	if Entity.player_exited:
		if !Entity.is_dealing_damage:
			return STATES.IDLE
	if Entity.can_attack:
		if !Entity.is_dealing_damage:
			return STATES.ATTACK
	if Entity.is_dealing_damage:
		return STATES.HIT
	if Entity.health <= Entity.health_min:
		return STATES.DEFEAT
	return null

func enter_state():
	$PrepareTimer.start(1)
	Entity.can_flip = false
	
	%Body2.play("Idle")
	Entity.can_attack = false
	Entity.movement_type = 7
	
	Entity.player_entered = false

func exit_state():
	Entity.can_flip = true
	

func stop_following():
	var distance = player.global_position - Entity.global_position
	
	if distance.length() >= 750:
		Entity.movement_type = 0
		

func _on_prepare_timer_timeout() -> void:
	Entity.can_attack = true
