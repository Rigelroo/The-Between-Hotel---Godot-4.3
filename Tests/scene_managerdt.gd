extends CanvasLayer
#
#
#signal transitioned_in()
#signal transitioned_out()
#
#@onready var animplayer: AnimationPlayer = $AnimationPlayer
#
#func transition_in() -> void:
	#animplayer.play("in")
	#await animplayer.animation_finished # Wait for the animation to finish
	#emit_signal("transitioned_in")
	#
#func transition_out() -> void:
	#animplayer.play("out")
	#await animplayer.animation_finished  # Wait for the animation to finish
	#emit_signal("transitioned_out")
#
#func transition_to(scene_path: String) -> void:
	#transition_in()
	#await transitioned_in
#
	#var new_scene = load(scene_path).instantiate()
	#var root = get_tree().root
#
	## Remove the current scene
	#var current_scene = root.get_child(root.get_child_count() - 1)
	#if current_scene:
		#current_scene.queue_free()  # Safe removal of the current scene
#
## Add the new scene
	#root.add_child(new_scene)
	#new_scene.name = "NewScene"  # Optional: name the new scene for easier reference
	#
## Optionally, handle signals or extra setup in the new scene
	#if new_scene.has_method("load_scene"):
		#new_scene.load_scene()
	#else:
		#print("New scene does not have a load_scene method.")
#
	## Wait for the new scene to be ready (if needed)
	#await new_scene.ready
	#transition_out()
	#await transitioned_out


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
		
		# Store current camera if needed
		current_camera = camera if camera else current_camera

		# Remove the current scene
		current_scene.player.remove_from_group("Player")
		current_scene.stats.remove_from_group("Stats")
		current_scene.gameover_manager.remove_from_group("Gameover")
		current_scene.queue_free()

	# Instantiate and add the new scene
	var new_scene = load(scene_path).instantiate()
	root.add_child(new_scene)
	
	# Restore or set up the camera
	var new_camera = new_scene.get_node("Camera2D")  # Adjust path as needed
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
		pass

	# Wait for the new scene to be ready
	

	transition_out()
	await transitioned_out
