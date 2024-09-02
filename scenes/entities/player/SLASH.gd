extends "state.gd"

@export var slashing = false
@export var can_doubleslash = true

@onready var sprite = $"../../Sprite2D"
#@onready var particles = $GPUParticles2D
@onready var timer = $Timer
@export var slash_duration = .2

func update(delta):
	
	if !slashing && can_doubleslash:
		$"../../AnimationPlayer".play("idle")
		return STATES.IDLE
	if can_doubleslash && Player.attack_input:
		$"../../AnimationPlayer".play("slash1")
	if Player.new_item_activate:
		$"../../AnimationPlayer".play("new_item")
		return STATES.NEWITEM
	
	return null
func enter_state():
	
	owner.velocity = Vector2()
	Player.attack_input = true
	slashing = true
	can_doubleslash = false
	timer.start(slash_duration)
	$"../../AnimationPlayer".play("slash2")
	can_doubleslash = true
	await $"../../AnimationPlayer".animation_finished
	slashing = false

func exit_state():
	slashing = false
