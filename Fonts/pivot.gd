@tool
extends RichTextEffect
class_name Pivot

var bbcode = "pivot"

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	var vertical_size = char_fx.env.get("vertical_size", 6.0)
	var pivot_index = char_fx.env.get("index", 0)

	char_fx.offset.y += (vertical_size * 
			abs(pivot_index - char_fx.relative_index)) *\
			( sin(char_fx.elapsed_time * 2) + 1) / 2
	return true
