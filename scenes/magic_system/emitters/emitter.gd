extends GPUParticles2D

@onready var subemitter: GPUParticles2D = $Subemitter

func _ready() -> void:
	add_to_group("Breathemitters")
func bye():
	remove_from_group("Breathemitters")
	queue_free()
