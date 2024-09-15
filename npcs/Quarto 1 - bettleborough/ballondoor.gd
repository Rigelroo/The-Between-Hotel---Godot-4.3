extends AnimatedSprite2D

func unlock():
	$AnimationPlayer.play("unlocking")
	play("unlocking")
	
