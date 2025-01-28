extends RigidBody2D
@onready var invmanager = InventoryManager
@export var coinmanager = SignalManager
@export var number = 1

func _ready() -> void:
	
	pass

func collectcoin():
	
	var manager = load("res://inventory/inventory_gui.gd").new()
	if coinmanager.coin_number < coinmanager.coin_max:
		coinmanager.insert()
		print(coinmanager.coin_number)
		queue_free()
		


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		collectcoin()
