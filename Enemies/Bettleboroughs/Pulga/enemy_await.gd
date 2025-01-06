extends EnemyState

signal attackfinished

var can_transition = false


func enter_state():
	super.enter_state()
	%Body2.play("Idle")
	%Attackcollision.disabled = true
	owner.can_return = true
	owner.set_physics_process(true)
	$Timer.start(0)


	#if get_parent().previous_state.name == "EnemyAttack":
		#$Timer.start(3)


func transition():
	if can_transition:
		var distance = player.global_position - owner.global_position
		if get_parent().previous_state == $"../EnemyAttack":
			if distance.length() > 190:
				owner.can_return = false
				get_parent().change_state("EnemyFollow")
		



func _on_timer_timeout() -> void:
	can_transition = true
	#var distance = owner.direction.lenght()
	
