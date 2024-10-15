extends Area2D

var player_in_area = false

func _ready() -> void:
	$AnimationPlayer.play("Ready")

#func _on_body_entered(body: Node2D) -> void:
	#if body.has_method("player"):
			#player_in_area = true
			#$AnimationPlayer.play("open")
			#$Balloon.play("mission")
#
#
#func _on_body_exited(body: Node2D) -> void:
	#if body.has_method("player"):
			#player_in_area = false
			#$AnimationPlayer.play("close")
			#$Balloon.play("inactive")

func _on_area_entered(area: Area2D) -> void:
	if area.owner.is_in_group("Player"):
		player_in_area = true
		$AnimationPlayer.play("open")
		$Balloon.play("mission")



func _on_area_exited(area: Area2D) -> void:
	if area.owner.is_in_group("Player"):
		player_in_area = false
		$AnimationPlayer.play("close")
		$Balloon.play("inactive")
