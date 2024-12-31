extends Sprite2D

@onready var gpu_particles_2d = $GPUParticles2D

@export_enum("cogumelo","broto","trevo","grama") var particlerange : int:
	set(value):
		if can:
			var vectr = [Vector2(0,0.1), Vector2(0.11,0.29), Vector2(0.3, 0.59), Vector2(0.6,1)]
			$GPUParticles2D.process_material.set("anim_offset", vectr[value])
			print(vectr[value])
		particlerange = value

var min_skew := -200
var max_skew := 200

func _on_Grass_area_entered(area: Node) -> void:
	if area.is_in_group("Interactionarea"):
		var body = area.owner
		var direction = global_position.direction_to(body.global_position)
		var skew = clamp(remap(body.velocity.length() * sign(-direction.x), -body.SPEED, body.SPEED, min_skew, max_skew), min_skew, max_skew)
		var tween = create_tween()
		tween.tween_property(self.material, "shader_parameter/skew", skew, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(self.material, "shader_parameter/skew", 0.0, 3.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
		
	else:
		pass
	if area.is_in_group("attackbox"):
		var body = area.owner
		cut(body)
var can = false
func _ready() -> void:
	can = true
	randomize()
	material.set("shader_param/offset", randi() % 3)
	particlerange = particlerange
	#frame = randi() % 2
	#position.y = randf_range(0, 5)

func cut(body_direction):
	self.texture = null
	if body_direction.sprite_2d.flip_h == true:
		$GPUParticles2D.scale.x = -1
	else:
		$GPUParticles2D.scale.x = 1
	$GPUParticles2D.emitting = true
