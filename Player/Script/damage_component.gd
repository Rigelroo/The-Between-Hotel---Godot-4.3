extends Node2D


@export var damage_value = 3
@export var damage_max = 5
@export var damage_min = 1
@export var crit_chance = 0.4
@onready var damage_numbers_origin = %DamagenumOrigin

func critical(area, value):
	var is_critical = crit_chance > randf()
	if is_critical:
		var damage_total = value * 2
		return [damage_total, true]
	else:
		return [value, false]

func deal_damage(value: int, area: Area2D):
	var damage = critical(area, value)
	%AnimationPlayer.play("Damage")
	Damagenumbers.display_number(damage[0], damage_numbers_origin.global_position, damage[1])
	
	%StatsComponent.currentHealth -= damage[0]


func deal_projectiledamage(value: int, area: Area2D):
	#var criticalchance = randi_range(1, 10)
	var damage_total = value
	var is_critical = area.crit_chance > randf()
	if is_critical:
		damage_total = value * 2
		
	#currentHealth -= damage_total
	#Damagenumbers.display_number(damage_total, damage_numbers_origin.global_position, is_critical)
	#stats.updatehealth()d
	#is_dealing_damage = true
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
	var direction = (owner.global_position - enemy.global_position).normalized() * (-owner.JUMP_VELOCITY * 2)
	owner.velocity.y += direction.y
	owner.move_and_slide()
