extends EnemyState

class_name EnemyAttack


var player : CharacterBody2D

@export var enemy: CharacterBody2D
@export var move_speed := 150.0


var move_direction : Vector2
var wander_time : float



func enter():
	%Body2.play("attack")
	player = get_tree().get_first_node_in_group("Player")
	print("attack ")




func physics_update(delta: float):
	var direction = player.global_position - enemy.global_position

	if direction.length() > 250:
		enemy.velocity = direction.normalized() * move_speed
	else:
		enemy.velocity = Vector2()
	
	if direction.length() > 530:
		Transitioned.emit(self, "EnemyIdle")

func attack_movement():
	var direction = player.global_position - enemy.global_position
	enemy.velocity = direction.normalized() * move_speed
