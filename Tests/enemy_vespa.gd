extends CharacterBody2D

var speed = 300

var velox = Vector2.ZERO


func _physics_process(delta: float) -> void:
	move_and_slide()
	
	if velocity.length() > 0:
		

#
#enum {
	#SURROUND,
	#ATTACK,
	#HIT,
#}
#
#var state = SURROUND
#
#func _physics_process(delta: float) -> void:
	#match state:
		#SURROUND:
			#move()
			#
#
#func move(target, delta):
	#var direction = (target - global_position).normalized()
	
