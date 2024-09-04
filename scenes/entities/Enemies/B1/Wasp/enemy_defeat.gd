extends EnemyState


var deadbody = preload("res://objects/deadbody.tscn")
var deadbodyspr = preload("res://Sprites/Bettlebourough/enemies/wasp/dead.png")
	#set(value):
		#player_entered = value
		#collision.set_deferred("disabled", value)
# Called when the node enters the scene tree for the first time.

func update(delta):
	Entity.movement_manager(delta)
	return null

func enter_state():
	%Hit.play("defeat")
	Entity.gravity_type = 2
	Entity.gravity_strength = 2
	Entity.set_physics_process(false)
	
func exit_state():
	Entity.speed = 150
	Entity.movement_type = 0


func death():
	var new_body = deadbody.instantiate()
	var parent = owner.get_parent()
		# Add the new node to your scene's node tree.
	print(parent)
	parent.add_child(new_body)
	if Entity.just_bool == false:
		new_body.rotation = -58
	if Entity.just_bool == true:
		new_body.rotation = -134.5
	new_body.texture = deadbodyspr
	new_body.scale = owner.scale
	
	new_body.global_position = owner.global_position
	Entity.queue_free()
	
