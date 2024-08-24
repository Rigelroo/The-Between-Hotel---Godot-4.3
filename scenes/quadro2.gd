extends Node2D
@onready var areaInteraction = $Area2D/AreaInteraction
@onready var player = $"."
@onready var global = $Global
#@export var can_interact = false
var player_in_area = false
var is_chatting = false
var Player = null
@export var dialog_event = 1

func _ready():
	$AnimatedSprite2D2.play("inactive")
	pass

	
func _process(delta: float) -> void:
	if player_in_area:
		if Input.is_action_pressed("Interact"):
				run_dialogue("dialogueexample")
	
	
	
func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	$AnimatedSprite2D2.play("interaction")
	if body.has_method("player"):
			player_in_area = true


func _on_area_2d_body_exited(body: CharacterBody2D) -> void:
	$AnimatedSprite2D2.play("inactive")
	if body.has_method("player"):
			player_in_area = false

func run_dialogue(dialogue_string):
	is_chatting = true
	
func _input(event: InputEvent):
	# check if a dialog is already running
	if player_in_area:
		if Dialogic.current_timeline != null:
			return
	
		if Input.is_action_pressed("Interact"):
			if dialog_event == 1:
				Dialogic.start('quadro2')
				get_viewport().set_input_as_handled()
