extends EnemyState

func update(delta):
	%MovementComponent.enemy_movement(delta)
	Entity.velocity.y += %MovementComponent.gravity(delta)
	if Entity.velocity.x != 0:
		%Body.play("walk")


func enter_state():
	%Body.play("walk")
	%MovementComponent.movement_type = 2

func exit_state():
	pass
