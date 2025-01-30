extends Node2D

class_name FastScenetransition

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func transition():
	animation_player.play("transition")
	await animation_player.animation_finished
	animation_player.play("detransition")

func _ready() -> void:
	if get_tree().current_scene.has_method("world"):
		get_tree().current_scene.fastscenet = self 
