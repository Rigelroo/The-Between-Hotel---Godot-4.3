extends EnemyState

func enter_state():
	super.enter_state()
	animation_body.play("attack")
