extends Node2D
#@onready var areaInteraction = $Area2D/AreaInteraction

#@onready var global = $Global
#@export var can_interact = false
var player_in_area = false
var is_chatting = false
var player = null

const MENUSELOS = preload("res://inventory/menuselos.tscn")
@export_file("*.tscn") var next_scene: String
@export_file var spritestr: String
@export var dialog_event = 1
@export var MAINMANAGER : MainManager = preload("res://Global/Mainmanager.tres")
@export var door_index : int = 0
@export var inventory_manager = preload("res://inventory/menuselos.tscn")
@export var door_key : InventoryItemb
@export var balloon : AnimatedSprite2D
@export var locked = false
var argument = null

@export var world : World

func no_key_func() -> void:
	Dialogic.start('doorlocked1')
	get_viewport().set_input_as_handled()


func has_key_func() -> void:
	if door_index == SignalManager.door_index:
		player = get_tree().get_first_node_in_group("Player")
		MAINMANAGER.floor1_doorlock[door_index] = false
		locked = MAINMANAGER.floor1_doorlock[door_index]
		balloon.play("unlocking")
		await balloon.animation_finished
		balloon.play("Door")

func _ready():
	SignalManager.has_key.connect(has_key_func)
	SignalManager.no_key.connect(no_key_func)
	locked = MAINMANAGER.floor1_doorlock[door_index]
	print("lock: ",locked)
	#$Ballondoor1.play("inactive")
	


func run_dialogue(dialogue_string):
	is_chatting = true
	
func _input(event: InputEvent):
	# check if a dialog is already running
	#if player_in_area:
		#if Dialogic.current_timeline != null:
			#return
	if player_in_area:
		if Dialogic.current_timeline != null:
			return
	
		if Input.is_action_pressed("enter"):
			if locked == false:
					#run_dialogue("dialogueexample")
					#get_tree().change_scene_to_file("res://Sprites/EntryHall/corridor1.tscn")
					SceneManager.transition_to(next_scene)
			elif locked == true:
				SignalManager.find_key(world.inventory.invslots, door_key, door_index)

	

		#if Input.is_action_pressed("Interact"):
			#if dialog_event == 1:
				#Dialogic.start('doortimeline1')
				#get_viewport().set_input_as_handled()


func _on_area_d_2d_1_area_entered(area: Area2D) -> void:
	if area.owner.is_in_group("Player"):
		player_in_area = true
		if locked == false:
			balloon.play("Door")
			
		else:
			balloon.play("locked")


func _on_area_d_2d_1_area_exited(area: Area2D) -> void:
	if area.owner.is_in_group("Player"):
		balloon.play("inactive")
		player_in_area = false
