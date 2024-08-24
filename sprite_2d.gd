extends Node2D
@export var target: Marker2D
func _ready() -> void:
	var t = create_tween()
	t.tween_property(self, "position", target.position, 2)
	t.tween_property(self, "scale", Vector2(2.0, 2.01), 1)
	#Tween.interpolate_value($Sprite, "scale", Vector2(0.1, 0.1), Vector2(1.0, 1.0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
