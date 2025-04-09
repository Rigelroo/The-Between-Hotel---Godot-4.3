extends Displayer


@onready var coinlabel = $Label

func _ready() -> void:
	sprite_texture = $sprite.texture
	if coinlabel:
		coinlabel.text = str(SignalManager.coin_number)
	
func update():
	if coinlabel:
		coinlabel.text = str(SignalManager.coin_number) 

func display_item(nameLabel: Label,descLabel: Label,showSprite: Sprite2D):
	nameLabel.text = item_name
	descLabel.text = flavor_text
	if showSprite.texture:
		showSprite.texture = sprite_texture
	showSprite.scale = Vector2(sprite_showscale_value, sprite_showscale_value)
