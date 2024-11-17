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
@export var test_event = 2
var pos = []

func load_savedstate():
	dialog_event

func savestate():
	pass
	#pos.append(position.x)
	#pos.append(position.y)
	#var array = {"dialog_event": dialog_event, "position": pos}
	#SaveSys.write_save_scene_state(array, "npc_KoriTrice", get_parent().scene_name)
	#print("test")

func loadstate():
	
	
	var state_data = null#SaveSys.read_save_scene_state()
	if state_data:
		if state_data.has(get_parent().scene_name) and state_data[get_parent().scene_name].has("npc_KoriTrice"):
			var npc_data = state_data[get_parent().scene_name]["npc_KoriTrice"]
			print(npc_data)  # Isso imprimirá o valor, por exemplo: [1, false]
			
			dialog_event = npc_data["dialog_event"]
func _ready():
	$AnimatedSprite2D2.play("inactive")
	$AnimatedSprite2D.play("default")

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.owner.is_in_group("Player"):
		$AnimatedSprite2D2.play("mission")
		player_in_area = true



func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.owner.is_in_group("Player"):
		$AnimatedSprite2D2.play("inactive")
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

	
				
func run_dialogue(_dialogue_string):
	is_chatting = true
	
func _input(_event: InputEvent):
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
