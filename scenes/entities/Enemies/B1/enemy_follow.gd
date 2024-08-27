extends EnemyState


@onready var collision = $"../../FollowArea/CollisionShape2D"

func enter_state():
	super.enter_state()
	owner.set_physics_process(true)
	animation_body.play("idle")

func exit_state():
	super.exit_state()
	owner.set_physics_process(false)

func transition():
	var distance = player.global_position - owner.global_position
	#var distance = owner.direction.lenght()
	
	if distance.length() < 250:
		owner.velocity = Vector2()
		get_parent().change_state("EnemyAttack")

#var player_entered: bool = false:
	#set(value):
		#player_entered = value
		#collision.set_deferred("disabled", value)
## Called when the node enters the scene tree for the first time.
#
#func transition():
	#if !player_entered:
		#get_parent().change_state("EnemyIdle")
		#
#
#func _on_follow_area_body_exited(body: Node2D) -> void:
	#if (body == player):
		#player_entered = false
