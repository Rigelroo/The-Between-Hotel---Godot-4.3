extends Node2D

signal Changecontainers(new_value)
signal healthChanged(new_value)

@export var minInk = 0
@export var maxInk = 100

@export var minHealth = 0
@export var HeartContainers = 3: 
	set(new_value):
		emit_signal("Changecontainers", new_value)
		HeartContainers = new_value
		

@export var currentInk = 100: 
	set(new_value):
		var stats_type = "inkpoints"
		currentInk = new_value
		SignalManager.emit_signal("stats_updated", [stats_type, new_value])

@export var currentHealth = 3: 
	set(new_value):
		var stats_type = "healthpoints"
		currentHealth = new_value
		emit_signal("healthChanged", new_value)
		SignalManager.emit_signal("stats_updated", [stats_type, new_value])
		print("currenthp ", currentHealth)

@export var currentFurypoints = 0:
	set(new_value):
		var stats_type = "berserkpoints"
		currentFurypoints = new_value
		SignalManager.emit_signal("stats_updated", [stats_type, new_value])





func set_stats():
	pass
