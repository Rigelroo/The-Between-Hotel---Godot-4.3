extends CharacterBody2D

@export var health_points : int = 5
var gravity_value = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var deadbodyspr : Texture
@onready var animplayer = $Body2
@onready var dropmarker: Marker2D = $Dropmarker
@onready var damage_numbers_origin = %DamagenumOrigin
@onready var hit_player = $Hit
const coin_instance = preload("res://inventory/Moedas/coin.tscn")
@export_enum("loop","linear") var patrol_type = "linear"
@export var path : PathFollow2D

@export var coin_amount: int = 1
@export var crit_chance: float = 0.3
@onready var movement_component: Node2D = %MovementComponent
@export_range(1, 1000, 0) var speed : int = 70

@export var damage_value : int = 5

func _ready() -> void:
	if velocity == Vector2.ZERO:
				velocity = Vector2.RIGHT * speed

func take_damage(amount: int, is_critical: bool):
	Damagenumbers.display_number(amount, damage_numbers_origin.global_position, false)
	health_points -= amount
	if health_points <= 0:
		hit_player.play("defeat")
		death()
	else:
		hit_player.play("hit")
		await hit_player.animation_finished
		hit_player.play("RESET")


func _physics_process(delta: float) -> void:
	%MovementComponent.enemy_movement(delta)
	velocity.y += %MovementComponent.gravity(delta)
	move_and_slide()



func create_coin():
	for i in range(coin_amount):
		var coin = coin_instance.instantiate()
		
		get_parent().call_deferred("add_child", coin)
		coin.global_position = dropmarker.global_position
		coin.apply_impulse(Vector2(randi_range(-300, 300), -250))



func _on_damage_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("attackbox"):
		if area.owner.has_method("player"):
			deal_damage(area.owner.damage_component.damage_value, area)
			area.owner.damage_component.knockback(self)


func _on_attackbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("Hitbox"):
		if area.owner.has_method("player"):
			var damage = self_critical(damage_value)
			area.owner.damage_component.deal_damage(damage, area)

func deal_damage(value: int, area: Area2D):
	var damage = critical(area, value)
	take_damage(damage[0], damage[1])

func self_critical(value):
	var is_critical = crit_chance > randf()
	if is_critical:
		var damage_total = value * 2
		return damage_total
	else:
		return value


func critical(area, value):
	var is_critical = area.owner.damage_component.crit_chance > randf()
	if is_critical:
		var damage_total = value * 2
		return [damage_total, true]
	else:
		return [value, false]

@export var deadbody : PackedScene = load("res://Objects/deadbody.tscn")


func death():
	create_coin()
	%Hit.play("defeat")
	await %Hit.animation_finished
	#await $VisibleOnScreenNotifier2D.is_on_screen() 
	%MovementComponent.movement_type = "Stopped"
	%MovementComponent.gravity_type = "Normal"
	deathbody()
	#call_deferred("queue_free")

func change_direction():
	if %Sprite.flip_h:
		%Sprite.flip_h = false
	else:
		%Sprite.flip_h = true

func deathbody():
	var new_body = deadbody.instantiate()
	var parent = owner.get_parent()
		# Add the new node to your scene's node tree.
	print(parent)
	parent.add_child(new_body)
	new_body.texture = deadbodyspr
	
	new_body.global_position = $Dropmarker.global_position
	queue_free()
	


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	pass # Replace with function body.


func _on_ground_detector_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	change_direction()
	velocity.x = -velocity.x 
