extends EnemyState

class_name EnemyIdle

@export var enemy: CharacterBody2D
@export var move_speed := 150.0


var move_direction : Vector2
var wander_time : float

func randomizer_wander():
	move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	wander_time = randf_range(1, 3)
	

func enter():
	randomizer_wander()

func update(delta: float):
	if wander_time > 0:
		wander_time -= delta
		
	else:
		randomizer_wander()
		

func physics_update(delta: float):
	if enemy:
		enemy.velocity = move_direction * move_speed
