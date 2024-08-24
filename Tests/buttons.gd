extends Control


func _on_button_sair_pressed() -> void:
	print("sair")
	get_tree().quit()


func _on_button_continue_pressed() -> void:
	print("continue")
	SceneManager.transition_to("res://scenes/entry_hallNode.tscn")
