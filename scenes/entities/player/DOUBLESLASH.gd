extends "state.gd"

var slashing = false
var can_doubleslash = true

@onready var sprite = $"../../Sprite2D"
@onready var particles = $GPUParticles2D
@onready var timer = $Timer
@export var slash_duration = .2

func update(delta):
	
	if !slashing:
		return STATES.FALL
	return null
func enter_state():
	Player.attack_input = true
	slashing = true
	can_doubleslash = false
	timer.start(slash_duration)
	$"../../AnimationPlayer".play("slash1")
	await $"../../AnimationPlayer".animation_finished
	can_doubleslash = false
	slashing = false

func exit_state():
	slashing = false
