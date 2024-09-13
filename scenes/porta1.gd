extends Node2D
#@onready var areaInteraction = $Area2D/AreaInteraction
@onready var player = $"."
#@onready var global = $Global
#@export var can_interact = false
var player_in_area = false
var is_chatting = false
var Player = null

@export_file("*.tscn") var next_scene: String
@export_file var spritestr: String
@export var dialog_event = 1
@export var MAINMANAGER : MainManager = preload("res://Global/Mainmanager.tres")
@export var door_index : int = 0

var locked = null
func _ready():
	locked = MAINMANAGER.floor1_doorlock[door_index]
	print("lock: ",locked)
	#$Ballondoor1.play("inactive")
	

	
func _process(delta: float) -> void:
	if player_in_area:
		if locked == false:
			if Input.is_action_pressed("Interact"):
					#run_dialogue("dialogueexample")
					#get_tree().change_scene_to_file("res://Sprites/EntryHall/corridor1.tscn")
					SceneManager.transition_to(next_scene)
		else:
			Dialogic.start('doorlocked')
			get_viewport().set_input_as_handled()
	
	
	
func _on_area_d_2d_1_body_entered(body: CharacterBody2D) -> void:
	if body.has_method("player"):
		if locked == false:
			$Ballondoor.play("Door")
			player_in_area = true
		else:
			$Ballondoor.play("locked")
			player_in_area = false


func _on_area_d_2d_1_body_exited(body: CharacterBody2D) -> void:
	if body.has_method("player"):
		$Ballondoor.play("inactive")
		player_in_area = false


func run_dialogue(dialogue_string):
	is_chatting = true
	
func _input(event: InputEvent):
	# check if a dialog is already running
	if player_in_area:
		if Dialogic.current_timeline != null:
			return
	
		#if Input.is_action_pressed("Interact"):
			#if dialog_event == 1:
				#Dialogic.start('doortimeline1')
				#get_viewport().set_input_as_handled()
