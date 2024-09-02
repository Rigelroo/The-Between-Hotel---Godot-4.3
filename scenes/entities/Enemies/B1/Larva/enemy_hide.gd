extends EnemyState

var can_resurge = false

	#set(value):
		#player_entered = value
		#collision.set_deferred("disabled", value)
# Called when the node enters the scene tree for the first time.

func update(delta):
	if can_resurge:
		
		return STATES.ACTIVE
	if Entity.health <= Entity.health_min:
		return STATES.DEFEAT

	return null

func enter_state():
	$"../../CollisionShape2D".disabled = true
	%Damagebox.disabled = true
	%Body.play("out")
	await $HideTimer.timeout
	
	%Body.play("activate_start")
	await %Body.animation_finished
	%Body.play("activate_middle")
	
	#%Body.stop()
	#await %Body.animation_finished
	#$HideTimer.start(7)
	#await $HideTimer.timeout
	##%Body.play("activate_start")
	##await %Body.animation_finished
	##%Body.play("activate_middle")
	##await %Body.animation_finished
	#can_resurge = true
	#%Hit.play("hit")

func start_timer():
	$HideTimer.start(4)

func exit_state():
	can_resurge = false


func _on_hide_timer_timeout() -> void:
	can_resurge = true
