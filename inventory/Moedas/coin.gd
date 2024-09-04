extends Area2D
@onready var invmanager = InventoryManager
@export var coinmanager : MainManager
@export var number = 1
func collectcoin():
	var manager = load("res://inventory/inventory_gui.gd").new()
	if coinmanager.coin_number < coinmanager.coin_max:
		coinmanager.insert()
		print(coinmanager.coin_number)
		queue_free()
		
