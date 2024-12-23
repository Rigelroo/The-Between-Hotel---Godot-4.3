class_name SceneTrigger extends Area2D

@onready var marker_2d: Marker2D = $Marker2D

@export_file("*.tscn") var next_scene: String

func _on_body_entered(body: Node2D) -> void:
	if "saved_position" in body:
		body.saved_position = [marker_2d.global_position.x, marker_2d.global_position.y]
		print(body.saved_position)
	SceneManager.transition_to(next_scene)
	
