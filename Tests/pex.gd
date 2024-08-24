
extends Node2D
#@onready var areaInteraction = $Area2D/AreaInteraction
@onready var player = $"."
#@onready var global = $Global
#@export var can_interact = false
var player_in_area = false
var is_chatting = false
var Player = null
var timeline : DialogicTimeline = DialogicTimeline.new()
@export var dialog_event = 1

func _ready():
	$AnimatedSprite2D2.play("inactive")
	#$AnimatedSprite2D.play("default")

func _on_area_2d_2_body_entered(body: CharacterBody2D) -> void:
	$AnimatedSprite2D2.play("mission")
	if body.has_method("player"):
			player_in_area = true



func _on_area_2d_2_body_exited(body: CharacterBody2D) -> void:
	$AnimatedSprite2D2.play("inactive")
	if body.has_method("player"):
			player_in_area = false

#func _process(delta: float) -> void:
	#if player_in_area:
		#if Input.is_action_pressed("Interact"):
			#if dialog_event == 1:
				#Dialogic.start("testdialogue")
				#dialog_event = dialog_event + 1
			#if dialog_event == 2:
				#Dialogic.start("test2dialogue")
				#dialog_event = dialog_event + 1

	
				
func run_dialogue(dialogue_string):
	is_chatting = true
	
func _input(event: InputEvent):
	# check if a dialog is already running
	if player_in_area:
		if Dialogic.current_timeline != null:
			return
	
		if Input.is_action_pressed("Interact"):
			if dialog_event == 1:
				Dialogic.start('testdialogue')
				dialog_event = 2
				get_viewport().set_input_as_handled()
			if dialog_event == 2:
				Dialogic.start('test2dialogue')
				get_viewport().set_input_as_handled()
