extends CanvasLayer

@onready var manager : MainManager = preload("res://Global/Mainmanager.tres")

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
	
	var new_scene = (scene)
	var root: Window = get_tree().get_root()
	
	#root.get_child(root.get_child_count() - 1).free()
	#root.add_child(new_scene)
	get_tree().change_scene_to_file(new_scene)

	
	
	#get_tree().find_child("EntryHall")
	manager.loaded.connect(awaitt)
	manager.loadscene.connect(cao)
	manager.loadscene.emit()
	
	#new_scene.activate()
signal vai
func cao():
	print("cao")
	var tween = create_tween()
	tween.tween_callback(_on_vai).set_delay(3)
	#vai.emit()

func _on_vai() -> void:
	transition_out()

func awaitt():
	print("awa")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "in":
		transitioned_in.emit()
		print("in")
	if anim_name == "out":
		transitioned_out.emit()
		print("out")
