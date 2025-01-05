extends "state.gd"

class_name Breathcontrol

@export var manager : MainManager

@onready var prep_timer = $Timer
var start_prept : bool = false
func update(delta):
	Player.velocity.y += Player.gravity(delta)
	#if Player.movement_input.x != 0 && !Player.is_in_water:
		#return STATES.MOVE
	#if Player.jump_input_actuation == true:
		#if !Player.is_in_water:
			#$"../../AnimationPlayer".play("jump_start")
			#return STATES.JUMP
	#if Player.velocity.y >0 && !Player.is_in_water:
		#$"../../AnimationPlayer".play("jump_end")
		#return STATES.FALL
	#if Player.dash_input and Player.can_dash && !Player.is_in_water:
		#return STATES.DASH
	#if Player.attack_input  && !Player.can_interact && !Player.is_in_water:
		#return STATES.SLASH
	#if Player.new_item_activate:
		#$"../../AnimationPlayer".play("new_item")
		#return STATES.NEWITEM
	#if Player.dying:
		#$"../../AnimationPlayer".play("Defeat")
		#return STATES.DEATH
	#if Player.is_in_water:
		#$"../../AnimationPlayer2".play("idle_swimming")
		#return STATES.INWATER




	if !Player.breath_input:
		#%Breathemitter.emitting = false
		breath_off()
		$"../../AnimationPlayer".play("idle")
		manager.deactivatestamina.emit()
		return STATES.IDLE
	return null
func enter_state():
	Player.new_emitter()
	await owner.new_emitter()
	owner.can_emit = true
	Player.is_skydiving = false
	Player.is_jumping = false
	
	
	Player.can_dash = true



func prep_starter() -> void:
	#var _bar = Staminabarnode
	$Timer.start(1)
	#bar.timer.start(5)
	

func _on_timer_timeout() -> void:
	$"../../AnimationPlayer".play("breath_end")

func breath_on():
	Player.emitterscene.emitting = true
	Player.emitterscene.subemitter.emitting = true
func breath_off():
	Player.emitterscene.emitting = false
	Player.emitterscene.subemitter.emitting = false
