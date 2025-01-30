extends Area2D

signal water_state_changed(is_in_water : bool)
var is_in_water : bool = false



func _on_area_entered(area: Area2D) -> void:
	if(is_in_water == false):
		var overlapping_bodies = get_overlapping_bodies()
		print("a")
		
		is_in_water = true
		self.water_state_changed.emit(is_in_water)
		
		print(water_state_changed)
		get_tree().current_scene.create_splash($"../Splashdetection/Marker2D", area.color)
		

func _on_area_exited(area: Area2D) -> void:
	var overlapping_bodies = get_overlapping_bodies()
	
	if (overlapping_bodies.size() == 0):
		is_in_water = false
		emit_signal("water_state_changed", is_in_water)
