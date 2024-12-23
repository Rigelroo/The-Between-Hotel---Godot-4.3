extends StaticBody2D

@onready var trampolim: Area2D = $trampolim

func _process(delta: float) -> void:
	pass


func _on_trampolim_body_entered(body: Node2D) -> void:
	if body.has_method("movable_entitie"):
		body.velocity += body.JUMP_VELOCITY



func _on_trampolim_area_entered(area: Area2D) -> void:
	if area.owner.has_method("movable_entitie"):
		if area.name == "Hitbox":
			area.owner.velocity.y += area.owner.JUMP_VELOCITY
