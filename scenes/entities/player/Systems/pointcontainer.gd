extends Panel

@onready var animationsprite = $first

@export var is_full : bool = false

func update_points(full: bool):
	if full:
		animationsprite.frame = 1
	else: 
		animationsprite.frame = 0
