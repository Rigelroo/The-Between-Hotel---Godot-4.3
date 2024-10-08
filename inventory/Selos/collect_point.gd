extends Node

@export var itemRes: Statspoints

func collectcontainer():
	SignalManager.insert_points(itemRes)
	queue_free()
	
