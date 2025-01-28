extends "state.gd"

@export var slashing = false
@export var can_doubleslash = true

@onready var sprite = $"../../Sprite2D"
#@onready var particles = $GPUParticles2D
@onready var timer = $Timer
@export var slash_duration = .2

func update(_delta):
	
	if !slashing && can_doubleslash:
		return STATES.FALL
	if can_doubleslash && Player.attack_input:
		$"../../AnimationPlayer".play("AirSlashcombo")
	if Player.new_item_activate:
		$"../../AnimationPlayer".play("new_item")
		return STATES.NEWITEM
	if Player.dying:
		$"../../AnimationPlayer".play("Defeat")
		return STATES.DEATH
	return null
func enter_state():

	Player.velocity.y = Player.velocity.y - 1
	Player.attack_input = true
	slashing = true
	can_doubleslash = false
	timer.start(slash_duration)
	if Player.prev_state == STATES.FALL:
		$"../../AnimationPlayer".play("AirSlashcombo")
	else:
		#$"../../AnimationPlayer".play("fall_start")
		$"../../AnimationPlayer".play("AirSlash")
	
	await get_tree().create_timer(0.35).timeout
	can_doubleslash = true
	slashing = false

func exit_state():
	slashing = false
