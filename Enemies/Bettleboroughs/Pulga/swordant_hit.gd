extends EnemyState

func update(delta):
	if Entity.velocity.x != 0:
		%Body.play("walk")


func enter_state():
	%Body.play("walk")
	$"../..".movement_type = 2

func exit_state():
	pass
