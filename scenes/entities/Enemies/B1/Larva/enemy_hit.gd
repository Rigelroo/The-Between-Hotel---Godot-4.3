extends EnemyState


var hide_chance = 0.4 > randf()
var can_hide = false
var can_go = false
	#set(value):
		#player_entered = value
		#collision.set_deferred("disabled", value)
# Called when the node enters the scene tree for the first time.

func update(delta):
	if !Entity.is_dealing_damage:
		if can_go:
			return STATES.ACTIVE
		if can_hide:
			return STATES.HIDE
		if Entity.health <= Entity.health_min:
			return STATES.DEFEAT
		
	
	return null

func enter_state():
	%Damagebox.disabled = false
	%Hit.play("hit")
	Entity.can_flip = false
	if hide_chance:
		can_hide = true
	elif !hide_chance:
		can_go = true
	await %Hit.current_animation_changed
	Entity.is_dealing_damage = false
	#%Hit.play("hit")
	
	
func exit_state():
	pass
