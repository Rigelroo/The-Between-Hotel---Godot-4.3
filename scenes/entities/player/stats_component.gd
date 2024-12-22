extends Node2D



@export var minInk = 0
@export var maxInk = 100

@export var minHealth = 0
@export var maxHealth = 100

@export var currentInk = 100: 
	set(new_value):
		var stats_type = "inkpoints"
		currentInk = new_value
		SignalManager.emit_signal("stats_updated", [stats_type, new_value])

@export var currentHealth = 100: 
	set(new_value):
		var stats_type = "healthpoints"
		currentHealth = new_value
		SignalManager.emit_signal("stats_updated", [stats_type, new_value])

@export var currentFurypoints = 0:
	set(new_value):
		var stats_type = "berserkpoints"
		currentFurypoints = new_value
		SignalManager.emit_signal("stats_updated", [stats_type, new_value])





func set_stats():
	pass
