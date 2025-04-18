extends CanvasLayer


signal transitioned_in()
signal transitioned_out()

@onready var animplayer: AnimationPlayer = $AnimationPlayer

# Reference to the current camera (if needed)
var current_camera: Camera2D = null

func transition_in() -> void:
	animplayer.play("in")
	
	await animplayer.animation_finished
	emit_signal("transitioned_in")

func transition_out() -> void:
	animplayer.play("out")
	await animplayer.animation_finished
	emit_signal("transitioned_out")

func transition_to(scene_path: String) -> void:
	transition_in()
	
	await transitioned_in

	# Get the player and camera from the current scene if necessary
	var root = get_tree().root
	var current_scene = root.get_child(root.get_child_count() - 1)

	if current_scene:
		var player = current_scene.get_node("Player")  # Replace "Player" with your player's node path
		var camera = current_scene.get_node("Camera2D")  # Replace "Camera2D" with your camera node path
		if current_scene.has_method("save_scenestate"):
			#current_scene.save_scenestate()
			pass
		# Store current camera if needed
		current_camera = camera if camera else current_camera

		# Remove the current scene
		if !current_scene.has_method("intro"):
			#pass
			#current_scene.player.remove_from_group("Player")
			#current_scene.stats.remove_from_group("Stats")
			#current_scene.gameover_manager.remove_from_group("Gameover")
			#await current_scene.tree_exited
			#SaveSys.save_all_states(current_scene.scene_name, current_scene.get_children())
			await SaveSys.save_all_states(current_scene.scene_name, current_scene.get_children())
		current_scene.queue_free()

	# Instantiate and add the new scene
	var new_scene = load(scene_path).instantiate()
	
	root.add_child(new_scene)
	
	# Restore or set up the camera
	var new_camera = new_scene.get_node("Camera2D") or null  # Adjust path as needed
	if new_camera:
		new_camera.current = true  # Ensure this camera is active
	elif current_camera:
# Add the previously stored camera if no camera is found in the new scene
		new_scene.add_child(current_camera)
		current_camera.current = true
	
	# Initialize the player in the new scene
	var new_player = new_scene.get_node("Player")  # Replace with the actual path
	
	if new_player:
		# Optionally, set the player's position or state as needed
		new_player.add_to_group("Player")
		pass
	var new_stats = new_scene.get_node("StatsLayer") or null
	if new_stats:
		new_stats.add_to_group("Stats")
	# Wait for the new scene to be ready
	#new_scene.loadscene()
	if !new_scene.has_method("intro"):
		await SaveSys.load_all_states(new_scene.scene_name, new_scene.get_children())
	await new_scene.loadscene()
	transition_out()
	await transitioned_out
