extends Node

@export var itemRes: InventoryItemb

func collectb(inventoryb: Inventoryb):
	inventoryb.insert(itemRes)
	queue_free()
#
#func collectb(inventoryb: Inventoryb):
	#inventoryb.insert(itemResb)
	#queue_free()
