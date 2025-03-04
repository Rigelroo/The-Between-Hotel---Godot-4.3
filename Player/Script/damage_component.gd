extends Node
class_name DamageComponent

@export var immunity_timer = 1.5
@export var damage_value = 3
@export var damage_max = 5
@export var damage_min = 1
@export var crit_chance = 0.4
@onready var damage_numbers_origin = %DamagenumOrigin

var can_deal_damage: bool = true

func critical(area, value):
	var is_critical = crit_chance > randf()
	if is_critical:
		var damage_total = value * 2
		return [damage_total, true]
	else:
		return [value, false]

func deal_damage(value: int, area: Area2D):
	if can_deal_damage:
		var damage = critical(area, value)
		%AnimationPlayer.play("Damage")
		Damagenumbers.display_number(damage[0], damage_numbers_origin.global_position, damage[1])
		%StatsComponent.currentHealth -= damage[0]
		can_deal_damage = false
	else:
		pass

func spikes_damage(value: int):
	if can_deal_damage:
		
		%AnimationPlayer.play("Damage")
		#Damagenumbers.display_number(value, damage_numbers_origin.global_position, damage[1])
		%StatsComponent.currentHealth -= value
		can_deal_damage = false
		
	else:
		pass


func deal_projectiledamage(value: int, area: Area2D):
	#var criticalchance = randi_range(1, 10)
	var damage_total = value
	var is_critical = area.crit_chance > randf()
	if is_critical:
		damage_total = value * 2

	%AnimationPlayer.play("Damage")
	area.collide()

func playdeath():
	if $StatsComponent.currentHealth <= $StatsComponent.minHealth:
		#dying = true
		pass

var knockback_power: int = 500

func knockback(enemy):
	var knockback_direction = (owner.global_position - enemy.global_position).normalized() * knockback_power
	owner.velocity = knockback_direction
	owner.move_and_slide()

func knockback_impulse(enemy):
	var direction = (owner.global_position - enemy.global_position).normalized() * (-owner.JUMP_VELOCITY * 3)
	owner.velocity.y = direction.y * 2
	owner.move_and_slide()


func _on_imunnity_timer_timeout() -> void:
	pass # Replace with function body.
