extends Node

@export var itemRes: Statspoints

func collect(inventory: Inventory):
	SignalManager.insert_stpoints(itemRes)
	queue_free()
	
