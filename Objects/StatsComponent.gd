@tool
extends Control

class_name StatsControl

@export var Points_visible_t := true:
	set(nv):
		Points_visible_t = nv
		var f = func():
			var tween = create_tween()
			if !nv:
				tween.tween_property($HBoxContainer, "modulate", Color(1,1,1,0), 0.5)
				tween.tween_property($HBoxContainer, "visible", false, 0.5)
			else:
				tween.tween_property($HBoxContainer, "visible", true, 0.5)
				tween.tween_property($HBoxContainer, "modulate", Color(1,1,1,1), 0.5)
		f.call()

var rest_timer := 3.0

func sleep_stats(hide: bool, delay: float):
	await get_tree().create_timer(rest_timer).timeout
	Points_visible_t = hide


func _ready() -> void:
	var nvsbl = func():
		$HBoxContainer.visible = false
		$HBoxContainer.modulate = Color(1,1,1,0)
	var vsbl = func():
		$HBoxContainer.visible = true
		$HBoxContainer.modulate = Color(1,1,1,1)
	
	SignalManager.showstats.connect(sleep_stats)
	SignalManager.inventoryopened.connect(nvsbl)
	SignalManager.inventoryclosed.connect(vsbl)
