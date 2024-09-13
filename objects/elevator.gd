extends Area2D

func _ready() -> void:
	$AnimationPlayer.play("RESET")

func _on_body_entered(body: Node2D) -> void:
	if body == Player:
			$AnimationPlayer.play("open")
			$Balloon.play("mission")


func _on_body_exited(body: Node2D) -> void:
	if body == Player:
			$AnimationPlayer.play("close")
			$Balloon.play("inactive")
