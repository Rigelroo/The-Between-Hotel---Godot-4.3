@icon("res://Missões/npc icons/Matheus.png")
extends Node2D
#@onready var areaInteraction = $Area2D/AreaInteraction
@onready var player = $"."

#@onready var global = $Global
#@export var can_interact = false
var player_in_area = false
var is_chatting = false
var Player = null
var timeline : DialogicTimeline = DialogicTimeline.new()
@export var dialog_event = 0
@export var quests : Array[Questtask] = []
@export var world : Node2D = self.owner

@export_file("*.dtl") var quest_completed_dialogue : Array[String] = []
@export var quest_array : int = 0
@export_file("*.dtl") var dialogs: Array[String] = []

func complete_quest():
	if quests[quest_array].completed:
		Dialogic.start(quest_completed_dialogue[quest_array])
func _ready():
	Dialogic.signal_event.connect(_on_dialogic_signal)
	$AnimatedSprite2D2.play("inactive")
	print("dialog = ",dialogs)
	#$AnimatedSprite2D.play("default")

func _on_area_2d_2_area_entered(area: Area2D) -> void:
	
	if area.owner.is_in_group("Player"):
		$AnimatedSprite2D2.play("mission")
		player_in_area = true



func _on_area_2d_2_area_exited(area: Area2D) -> void:
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

	
				
func run_dialogue(dialogue_string):
	is_chatting = true
	
func _input(event: InputEvent):
	# check if a dialog is already running
	if player_in_area:
		if Dialogic.current_timeline != null:
			return
	
		if Input.is_action_pressed("Interact"):
			#SignalManager.findquest(SignalManager.task_manager.missions, quests[quest_array], quest_array, quests[quest_array].item_amount, quests[quest_array].item_amount)
			SignalManager.finditem_amount(world.inventory.invslots, quests[quest_array].quest_item, quest_array, quests[quest_array].item_amount)
			Dialogic.start(dialogs[dialog_event])
			dialog_event = 1
			get_viewport().set_input_as_handled()

func _on_dialogic_signal(argument:String):
	if argument == "set_mission":
		var quest = quests[Dialogic.VAR.mission_index]
		SignalManager.task_manager.insert(quest)
		print("New_mission!")
		
