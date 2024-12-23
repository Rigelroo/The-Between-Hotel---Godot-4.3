extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var sprite_2d_2: Sprite2D = $Sprite2D2
@onready var logomarca: Sprite2D = $Logomarca
@export_file("*.tscn") var next_scene: String

func _ready() -> void:
	$AnimationPlayer.play("surge")
	await $AnimationPlayer.animation_finished
	$Timer.start(3)
	await $Timer.timeout
	$AnimationPlayer.play("out")
	await  $AnimationPlayer.animation_finished
	SceneManager.transition_to(next_scene)
	



func _process(delta: float) -> void:
	pass
	if Input.is_anything_pressed():
		$Timer.stop()
		$Timer.timeout.emit()


func intro():
	pass
