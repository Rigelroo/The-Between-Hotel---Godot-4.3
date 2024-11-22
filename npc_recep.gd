extends Node2D
#@onready var areaInteraction = $Area2D/AreaInteraction
@onready var player = $"."
#@onready var global = $Global
#@export var can_interact = false
var timeline : DialogicTimeline = DialogicTimeline.new()
@export var dialog_event = 0
@export var quests : Array[Questtask] = []
@export var world : Node2D = self.owner

@export_file("*.dtl") var quest_completed_dialogue : Array[String] = []
@export var quest_array : int = 0
@export_file("*.dtl") var dialogs: Array[String] = []

#@export var dialog_event = 1
@export var test_event = 2
var player_in_area = false
var is_chatting = false
var Player = null

var pos = []

func load_savedstate():
	dialog_event

func save():
	var pos = [position.x, position.y]
	var npc_data = {
		"dialog_event": dialog_event,
		"position": pos
	}
	
	# Salvar no SaveSys
	SaveSys.save_scene_state(get_parent().scene_name, "npc_KoriTrice", npc_data)

func load_player_state():
	var npc_data = SaveSys.load_scene_state(get_parent().scene_name, "npc_KoriTrice")
	if npc_data != null:
		dialog_event = npc_data["dialog_event"]
		var pos_data = npc_data["position"]
		if pos_data.size() == 2:
			position = Vector2(pos_data[0], pos_data[1])


func savestate(slot: int, npc_name: String):
	# Posicionamento do NPC
	pos = [position.x, position.y]
	
	# Dados do NPC
	var npc_data = {
		"dialog_event": dialog_event,
		"position": pos
	}
	
	# Salvar dados no SaveSys no slot correto
	var slot_data = SaveSys.read_slot_data(slot)
	if slot_data == null:
		slot_data = {}
	
	if not slot_data.has("npc_states"):
		slot_data["npc_states"] = {}
	
	slot_data["npc_states"][npc_name] = npc_data

	SaveSys.save_slot_data(slot, slot_data)
	print("Estado salvo para o NPC no slot %d" % slot)

func loadstate(slot: int, npc_name: String):
	# Recuperar os dados do slot
	var slot_data = SaveSys.read_slot_data(slot)
	
	if slot_data["npc_states"].has(npc_name):
		var npc_data = slot_data["npc_states"][npc_name]
		
		# Aplicar os dados ao NPC
		dialog_event = npc_data["dialog_event"]
		var pos_data = npc_data["position"]
		if pos_data.size() == 2:
			position = Vector2(pos_data[0], pos_data[1])
		
		print("Estado carregado para NPC no slot %d: %s" % [slot, str(npc_data)])
	else:
		print("Nenhum estado salvo encontrado para NPC no slot %d" % slot)
#func savestate():
	#pos.append(position.x)
	#pos.append(position.y)
	#var array = {"dialog_event": dialog_event, "position": pos}
	#SaveSys.write_save_scene_state(array, "npc_KoriTrice", get_parent().scene_name)
#
#func loadstate():
	#
	#
	#var state_data = null#SaveSys.read_save_scene_state()
	#if state_data:
		#if state_data.has(get_parent().scene_name) and state_data[get_parent().scene_name].has("npc_KoriTrice"):
			#var npc_data = state_data[get_parent().scene_name]["npc_KoriTrice"]
			#print(npc_data)  # Isso imprimirá o valor, por exemplo: [1, false]
			#
			#dialog_event = npc_data["dialog_event"]
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
			#SignalManager.findquest(SignalManager.task_manager.missions, quests[quest_array], quest_array, quests[quest_array].item_amount, quests[quest_array].item_amount)
			#SignalManager.finditem_amount(world.inventory.invslots, quests[quest_array].quest_item, quest_array, quests[quest_array].item_amount)
			Dialogic.start(dialogs[dialog_event])
			dialog_event = 1
			get_viewport().set_input_as_handled()
