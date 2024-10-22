extends Control

func _ready() -> void:
	SignalManager.its_saving.connect(set_saving)
	$CenterContainer.visible = false

func set_saving():
	$CenterContainer.visible = true
	$CenterContainer/Sprite2D/AnimationPlayer.play("saving")
	$Timer.start(3)




func _on_timer_timeout() -> void:
	$CenterContainer.visible = false
	$CenterContainer/Sprite2D/AnimationPlayer.stop()
