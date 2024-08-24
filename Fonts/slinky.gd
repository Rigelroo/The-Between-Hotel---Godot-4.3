@tool
extends RichTextEffect
class_name Slinky

var bbcode = "slinky"

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	var speed = char_fx.env.get("speed", 1)
	char_fx.offset.x += pow(char_fx.relative_index * (sin(char_fx.elapsed_time * speed)), 2)
	return true
