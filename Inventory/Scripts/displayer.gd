extends Button

class_name Displayer

@export var manager : MainManager
@export var item_name : String
@export_multiline var flavor_text : String
var sprite_texture : Texture2D
@export var sprite_showscale_value : float = 1


func _ready() -> void:
	if $sprite:
		sprite_texture = $sprite.texture
	
func update() -> void:
	pass

func display_item(nameLabel: Label,descLabel: Label,showSprite: Sprite2D) -> void:
	pass
