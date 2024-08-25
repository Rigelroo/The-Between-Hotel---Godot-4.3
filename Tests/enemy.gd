extends CharacterBody2D



var speed = 150
@onready var hit_player = $Hit
@onready var animplayer = $Body2
@export var is_pulg_chase : bool = false
@export var player = Global.player_body
var health = 80
var health_max = 80
var health_min = 0

var dead: bool = false
var taking_damage : bool = false
var damage_to_deal = 20
var is_dealing_damage: bool = false

var dir: Vector2
const gravity = 900
var knockback_force = 10000
var is_roaming: bool = true
@onready var Raycasts = $Raycasts

func _process(delta: float) -> void:
	for raycast in Raycasts.get_children():
		raycast.force_raycast_update() 
		if raycast.is_colliding():
			if raycast == $Raycasts/Rightraycast:
				dir = Vector2.LEFT
			elif raycast == $Raycasts/Leftraycast:
				dir = Vector2.RIGHT
	if !is_on_floor():
		pass
	move(delta)
	handle_animation()
	move_and_slide()

func handle_animation():
	if is_dealing_damage:
		$Body2.stop()
	if !is_dealing_damage:
		pass
	if !dead && !taking_damage && !is_dealing_damage:
		if velocity.x != 0:
			pass
		if velocity.x == 0:
			pass
		if dir.x == -1:
			$Sprite2D.flip_h = false
			$Sprite2D2.flip_h = false
			$Sprite2D3.flip_h = false
		elif dir.x == 1:
			$Sprite2D.flip_h = true
			$Sprite2D2.flip_h = true
			$Sprite2D3.flip_h = true

	
func move(delta):
	if !dead:
		if !is_pulg_chase:
			velocity += dir * speed * delta
		elif is_pulg_chase and !is_dealing_damage:
			var dir_to_player = position.direction_to(player.position) * speed
			velocity = dir_to_player
			dir.x = abs(velocity.x) / velocity.x
		is_roaming = true
	elif dead:
		velocity.x = 0
func _on_directiontimer_timeout() -> void:
	$Directiontimer.wait_time = choose([1.5,2.0,2.5,5,7,3.5])
	if !is_pulg_chase:
		dir = choose([Vector2.RIGHT, Vector2.LEFT])
		velocity.x = 0
func choose(array):
	array.shuffle()
	return array.front()


func _on_damage_area_area_entered(area: Area2D) -> void:
	if (area == player.slashbox) or (area == player.slashbox_down):
		damage()
	if (area == player.slashbox_down):
		pass
func damage():
	is_dealing_damage = true
	play_knockback()
	hit_player.play("hit")
	await hit_player.animation_finished
	is_dealing_damage = false
	$Body2.play("Idle")
	print("hit")

var knockback = Vector2.ZERO


func play_knockback():
	var direction = -global_position.direction_to(player.global_position)
	var force = direction * knockback_force
	velocity = (direction * speed * 3 + knockback)

	$KnockbackTimer.start(0.7)
	await $KnockbackTimer.timeout
	velocity -= velocity


func _on_follow_area_body_entered(body: Node2D) -> void:
	is_pulg_chase = true


func _on_follow_area_body_exited(body: Node2D) -> void:
	is_pulg_chase = false
