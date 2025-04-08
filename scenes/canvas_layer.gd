extends CanvasLayer

class_name Canvas

@export var inventory : Control

@onready var control: Control = $Control

func _physics_process(delta: float) -> void:
	if control:
		control.proc()
