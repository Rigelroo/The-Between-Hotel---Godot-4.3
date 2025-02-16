extends Panel

class_name HealthContainer

@onready var sprite_2d: Sprite2D = $Sprite2D
var points := 0:
	set(nv):
		points = nv
		update_points()

func update_points():
	if sprite_2d:
		match points:
			0: sprite_2d.frame = 0
			1: sprite_2d.frame = 1
			2: sprite_2d.frame = 2
