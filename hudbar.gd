extends Node2D

class_name HudBar

@export var lifemeter : AnimatedSprite2D
@export var inkmeter : AnimatedSprite2D
@export var manager : CoinManager



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	lifemeter.frame = manager.lifepoints
	inkmeter.frame = manager.inkpoints
