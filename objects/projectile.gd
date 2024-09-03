extends CharacterBody2D

var direction : int
var speed : int = 600
var player : CharacterBody2D
var dir: Vector2

func _physics_process(delta: float) -> void:
	var dir_to_player = position.direction_to(player.position) * speed
	velocity = dir_to_player
	

func _on_timer_timeout() -> void:
	queue_free()

func _ready() -> void:
	print("fire")
	ready.emit()
	player = get_tree().get_first_node_in_group("Player")
