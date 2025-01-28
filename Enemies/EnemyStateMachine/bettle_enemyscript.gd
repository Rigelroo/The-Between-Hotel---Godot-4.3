extends CharacterBody2D

@export var health_points : int = 5
var gravity_value = ProjectSettings.get_setting("physics/2d/default_gravity")


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



func deal_damage(value: int, area: Area2D):
	var damage = critical(area, value)
	take_damage(damage[0], damage[1])

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
	
	#await $VisibleOnScreenNotifier2D.is_on_screen() 
	call_deferred("queue_free")



func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	pass # Replace with function body.
