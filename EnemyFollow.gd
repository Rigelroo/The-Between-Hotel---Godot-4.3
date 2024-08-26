extends "enemy_state.gd"



signal Attackmove

var player : CharacterBody2D

@export var enemy: CharacterBody2D
@export var move_speed := 150.0


var move_direction : Vector2
var wander_time : float

func randomizer_wander():
	move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	wander_time = randf_range(1, 3)
	

func enter():
	player = get_tree().get_first_node_in_group("Player")
	print("i")


func physics_update(delta: float):
	var direction = player.global_position - enemy.global_position

	if direction.length() > 250:
		enemy.velocity = direction.normalized() * move_speed
	else:
		enemy.velocity = Vector2()
		Transitioned.emit(self, "EnemyAttack")
	
	if direction.length() > 530:
		Transitioned.emit(self, "EnemyIdle")


func update(_delta):
	if Player.velocity.x == 0:
		return STATES.IDLE
	return null

func enter_state():
	pass
	$"../../AnimationPlayer".play("run")
