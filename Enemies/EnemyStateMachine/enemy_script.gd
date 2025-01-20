extends CharacterBody2D

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

func take_damage(amount: int, is_critical: bool):
	Damagenumbers.display_number(amount, damage_numbers_origin.global_position, false)
	hit_player.play("hit")

func _physics_process(delta: float) -> void:
	%MovementComponent.enemy_movement(delta)
	velocity.y += %MovementComponent.gravity(delta)
	move_and_slide()

func die():
	create_coin()


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
