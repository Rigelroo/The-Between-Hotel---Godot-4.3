extends Sprite2D

func _ready():
	ghosting()
	
func set_property(tx_pos: Vector2, tx_scale: Vector2, tx_flip_h: bool):
	position = tx_pos
	scale = tx_scale
	self.flip_h = tx_flip_h
	print("a")


func ghosting():
	var tween_fade = get_tree().create_tween()
	
	tween_fade.tween_property(self, "self_modulate",Color(1, 1, 1, 0),1.75)
	await tween_fade.finished
	
	queue_free()
