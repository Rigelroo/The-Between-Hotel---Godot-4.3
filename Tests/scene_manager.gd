extends CanvasLayer



signal transitioned_in()
signal transitioned_out()

@onready var animplayer: AnimationPlayer = $AnimationPlayer

func transition_in() -> void:
	animplayer.play("in")

func transition_out() -> void:
	animplayer.play("out")

func transition_to(scene: String) -> void:
	transition_in()
	await transitioned_in
	
	var new_scene = load(scene).instantiate()
	var root: Window = get_tree().get_root()
	
	root.get_child(root.get_child_count() - 1).free()
	root.add_child(new_scene)
	
	new_scene.load_scene()
	new_scene.loaded.connect(awaitt)
	await new_scene.loaded
	transition_out()
	await transitioned_out
	new_scene.activate()
func awaitt():
	print("awa")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "in":
		transitioned_in.emit()
		print("in")
	if anim_name == "out":
		transitioned_out.emit()
		print("out")
