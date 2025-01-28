extends GPUParticles2D


func _physics_process(delta: float) -> void:
	if %AnimationPlayer.current_animation != "HerculesLeaf_moving":
		emitting = false
