extends Node

@export var itemRes: InventoryItem

func _ready() -> void:
	$Sprite2D.texture = itemRes.texture

func collect(inventory: Inventory):
	inventory.insert(itemRes)
	queue_free()
	
