extends "state.gd"

var dash_direction = Vector2.ZERO
var dash_speed = 940
var dashing = false
@onready var sprite = $"../../Sprite2D"
@export var ghost_node : PackedScene
#@onready var ghost_timer = $GhostTimer
#@onready var particles = $GPUParticles2D

@export var dash_duration = .2
@onready var DashDuration_timer = $DashDuration
#@onready var dash_particle_left = $"../../GPUParticles2D3"
#@onready var Dash_spriteR = $DashRight
#@onready var Dash_spriteL = $DashLeft
func update(delta):
	$"../../AnimationPlayer".play("dash")
	if !dashing:
		return STATES.FALL
	if Player.new_item_activate:
		$"../../AnimationPlayer".play("new_item")
		return STATES.NEWITEM
	if Player.dying:
		$"../../AnimationPlayer".play("Defeat")
		return STATES.DEATH
		
	if Player.is_in_water:
		$"../../AnimationPlayer2".play("idle_swimming")
		return STATES.INWATER
	return null
func enter_state():
	
	if Player.facing_direction:
		pass
		#$"../../GPUParticles2D2".get_texture(Dash_spriteL)
	if  !Player.facing_direction: 
		pass
		#$"../../GPUParticles2D2".scale(Dash_spriteR)
	
	Player.can_dash = false
	dashing = true
	DashDuration_timer.start(dash_duration)
	if Player.movement_input != Vector2.ZERO:
		dash_direction = Player.movement_input
	else:
		dash_direction = Player.last_direction
	Player.velocity = dash_direction.normalized() * dash_speed
func exit_state():
	dashing = false

	pass # Replace with function body.
func add_ghost():
	var ghost = ghost_node.instantiate()
	ghost.set_property($"../..".position,$"../../Sprite2D".scale)
	get_tree().current_scene.add_child(ghost)



func _on_ghost_timer_timeout():
	add_ghost()
	
	


func _on_dash_duration_timeout() -> void:
	dashing = false
	pass # Replace with function body.
