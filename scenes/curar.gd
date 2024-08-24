extends Area2D


@export var manager : CoinManager
@export var player : Player
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	player.get_out_item.connect(some)
	
func heal():
	pass
	


func some() -> void:
	self.queue_free()
	print("curou")
