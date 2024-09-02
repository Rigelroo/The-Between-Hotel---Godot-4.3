extends EnemyState

# Called when the node enters the scene tree for the first time.
var can_attack = false

func update(delta):
	var distance = player.position - Entity.global_position
	if distance.length() > 430:
		%Body.play("out")
		return STATES.INACTIVE
	if can_attack && !Entity.is_dealing_damage:
		return STATES.ATTACK
	if Entity.health <= Entity.health_min:
		return STATES.DEFEAT
	if Entity.is_dealing_damage:
		return STATES.HIT
	return null

func enter_state():
	$"../../CollisionShape2D".disabled = false
	can_attack = false
	%Damagebox.disabled = false
	#if Entity.prev_state != STATES.ATTACK:
		#pass

	
	%PrepareTimer.start(1.5)
	if Entity.prev_state == STATES.CLOSE:
		%Body.play("activate_start")
		await %Body.animation_finished
		%Body.play("activate_middle")
		await %Body.animation_finished
		%Body.play("idle")
	
		%PrepareTimer.start(2)
		
		


func _on_prepare_timer_timeout() -> void:
	can_attack = true


func exit_state():
	can_attack = false
	
