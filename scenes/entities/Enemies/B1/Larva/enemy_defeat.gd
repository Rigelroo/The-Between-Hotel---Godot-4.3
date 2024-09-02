extends EnemyState


var deadbody = preload("res://objects/deadbody.tscn")
var deadbodyspr = preload("res://Sprites/Bettlebourough/enemies/wasp/dead.png")
	#set(value):
		#player_entered = value
		#collision.set_deferred("disabled", value)
# Called when the node enters the scene tree for the first time.

func update(delta):
	return null

func enter_state():
	
	%Body.play("defeat")
	Entity.set_physics_process(false)
	
func exit_state():
	pass


func death():
	Entity.queue_free()
	
