extends EnemyState

@onready var collision = $"../../FollowArea/CollisionShape2D"

var player_entered: bool = false:
	set(value):
		player_entered = value
		collision.set_deferred("disabled", value)
# Called when the node enters the scene tree for the first time.

func transition():
	if player_entered:
		get_parent().change_state("EnemyFollow")
		


func _on_follow_area_body_entered(body: Node2D) -> void:
	if (body == player):
		player_entered = true
