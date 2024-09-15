class_name SceneTrigger extends Area2D


@export_file("*.tscn") var next_scene: String

func _on_body_entered(body: Node2D) -> void:
	SceneManager.transition_to(next_scene)
