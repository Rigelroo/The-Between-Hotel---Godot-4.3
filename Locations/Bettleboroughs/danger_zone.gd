extends Area2D

class_name DangerZone

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Interactionarea"):
		SignalManager.emit_signal("showstats", true, 0.5)

func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("Interactionarea"):
		SignalManager.emit_signal("showstats", false, 0.5)
