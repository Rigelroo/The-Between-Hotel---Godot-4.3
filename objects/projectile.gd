extends Area2D

var direction: Vector2 = Vector2.RIGHT

@export var damage: int = 1
@export var crit_chance : float = 0.3

var speed : float = 300

func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	

func _on_screen_exited() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.deal_projectiledamage(damage, self)

func collide():
	var tween = create_tween()
	$CollisionShape2D.disabled = true
	$AnimatedSprite2D.visible = false
	$GPUParticles2D.emitting = true
	get_tree().create_timer(1,true)
	await get_tree().create_timer(1,true).timeout
	queue_free()



#var direction : int
#var speed : int = 600
#var player : CharacterBody2D
#var dir: Vector2
#
#func _physics_process(delta: float) -> void:
	#var dir_to_player = position.direction_to(player.position) * speed
	#velocity = dir_to_player
	#
#
#func _on_timer_timeout() -> void:
	#queue_free()
#
#func _ready() -> void:
	#print("fire")
	#ready.emit()
	#player = get_tree().get_first_node_in_group("Player")
