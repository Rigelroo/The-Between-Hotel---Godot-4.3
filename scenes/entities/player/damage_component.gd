extends Node2D


var damage_value = null
var damage_max = null
var damage_min = null
var crit_chance = null

func deal_damage(value: int, area: Area2D):
	#var criticalchance = randi_range(1, 10)
	var damage_total = value
	var is_critical = area.owner.crit_chance > randf()
	
	if is_critical:
		damage_total = value * 2
		
	#currentHealth -= damage_total
	#Damagenumbers.display_number(damage_total, damage_numbers_origin.global_position, is_critical)

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
	$AnimationPlayer.play("Damage")
	area.collide()

func playdeath():
	if $StatsComponent.currentHealth <= $StatsComponent.minHealth:
		#dying = true
		pass
