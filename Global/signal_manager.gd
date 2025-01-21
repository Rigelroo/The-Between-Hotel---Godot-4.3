extends Node

signal its_saving
signal scene_loaded
signal stamp_equipped
signal stamp_unequipped
signal just_equip
signal world_loaded
signal magic_changed

var stats_type
var new_value

signal stats_updated(stats_type, new_value)
signal new_taskprogress(task)

signal no_enough_stpoints
signal try_key
signal has_key
signal no_key
signal has_item
signal no_item
signal has_correct_amount
signal no_correct_amount

signal inventoryclosed
signal inventoryopened

signal update_quests
signal point_update

var can_update : bool = false



@export_file("*.mp3") var sfx_array : Array[String] = ["res://Sound/Testmusic&sounds/traditional-stamp-44189.mp3","res://Sound/Testmusic&sounds/undertale-damage-taken_0iH1Nxl.mp3"]
var have_correct_key = false
var have_correct_item = false
var have_correct_amount = false

var door_index = false
var npc_index = false

@export var greed_number : float = 0.4

@export_subgroup("Stamp System")
@export var stamp_points : int = 5
@export var max_stamp_points : int = 5

@export var greed_equiped : bool = false
@export var hleaf_equiped : bool = false
@export var hatintime_equiped : bool = false
@export var shadowdiver_equiped : bool = false
@export var crimsonfury_equiped : bool = false
@export var frozenheart_equiped : bool = false
@export var ffemblem_equiped : bool = false

var can_showmouse = false

var mouse_visible = false:
	set(new_value):
		if !new_value:
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

var can_emit_item_and_amount: bool = false:
	set(new_value):
		can_emit_item_and_amount = new_value
		if can_emit_item_and_amount:
			if have_correct_item:
				has_correct_amount.emit()
			elif !have_correct_key:
				no_correct_amount.emit()
		can_emit_item_and_amount = false
		have_correct_item = false
		have_correct_amount = false

var can_emit_item: bool = false:
	set(new_value):
		can_emit_item = new_value
		if can_emit_item:
			if have_correct_item:
				has_item.emit()
			elif !have_correct_item:
				no_item.emit()
		can_emit_item = false
		have_correct_item = false
		have_correct_amount = false

var can_emit_key: bool = false:
	set(new_value):
		can_emit_key = new_value
		if can_emit_key:
			if have_correct_key:
				has_key.emit()
			elif !have_correct_key:
				no_key.emit()
		can_emit_key = false
		have_correct_key = false

var breath_index : int = 0:
	set(new_value):
		breath_index = new_value
		magic_changed.emit()
		print("emitter index: ", breath_index)

@onready var ItemStackGuiClass = preload("res://inventory/gui/itemStackGui.tscn")
@onready var ItemStackGuiClassb = preload("res://inventory/gui/itemStackGuib.tscn")
@onready var ItemStackGuiClassc = preload("res://inventory/gui/itemStackGuic.tscn")
@onready var inventory: Inventory = preload("res://inventory/PlayerInventory.tres")
@onready var inventoryb: Inventoryb = preload("res://inventory/PlayerInventoryb.tres")
@onready var inventoryc: Inventoryc = preload("res://inventory/PlayerInventoryc.tres")
@onready var task_manager: TaskManager = preload("res://Global/Task_manager.tres")
@onready var main_manager : MainManager = preload("res://Global/Mainmanager.tres")
var player = null

func equipstamp(slots: Array, sealslots: Array, currently_selected: int, inventoryc: Inventoryc):

		var sealslot = sealslots
		var slotf = slots[currently_selected]
		if !slotf.isEmpty():
			
				
				print(slotf.itemStackGui.inventorySlot.item)
				if slotf.itemStackGui.inventorySlot.item.itemactivate == 0:
					if stamp_points >= slots[currently_selected].itemStackGui.inventorySlot.item.stamp_points:
						var sound_load = load(sfx_array[0])
						VfxPlayer.set_stream(sound_load)
						VfxPlayer.play()
						stamp_points -= slots[currently_selected].itemStackGui.inventorySlot.item.stamp_points
						inventoryc.insert(slotf.itemStackGui.inventorySlot.item)
						slotf.itemStackGui.inventorySlot.item.itemactivate = 1
					else:
						no_enough_stpoints.emit()
						var sound_load = load(sfx_array[1])
						VfxPlayer.set_stream(sound_load)
						VfxPlayer.play()
				elif slotf.itemStackGui.inventorySlot.item.itemactivate == 1:
						stamp_points += slots[currently_selected].itemStackGui.inventorySlot.item.stamp_points
						inventoryc.insert(slotf.itemStackGui.inventorySlot.item)
						slotf.itemStackGui.inventorySlot.item.itemactivate = 0



func stamp_equippedfunc(slots: Array,currently_selected: int, inventory: Inventory):
	
		
		#changetexture_equip()
		var slot = slots[currently_selected]
		var secondary = slot.itemStackGui.inventorySlot.item.scriptstr
		var itemscript = load(secondary).new()
		print("stamp equip: ",slot.itemStackGui.inventorySlot.item.name)
		
		slot = slots[currently_selected]
		secondary = slot.itemStackGui.inventorySlot.item.scriptstr
		itemscript = load(secondary).new()
		
		
		itemscript.activatestamp()
		#slots[currently_selected].modulateslot()
		slot.itemStackGui.inventorySlot.amount = 0
		print("é esse aqui ó -> ", slots[currently_selected].itemStackGui.inventorySlot.item.name, " num: ",currently_selected)
		inventory.updated.emit()

func stamp_unequippedfunc(slots: Array,currently_selected: int, inventory: Inventory):
	var slot = slots[currently_selected]
	var secondary = slot.itemStackGui.inventorySlot.item.scriptstr
	var itemscript = load(secondary).new()
	print("stamp unequip")
	slot.itemStackGui.inventorySlot.amount = 1
	inventory.updated.emit()
	itemscript.deactivatestamp()
	
	

var scr_key = null
var kscript = null


func findquest(questslots, chosed_item, index, amount, item_type):
	var arg_has_key = true
	var arg_no_key = false
	npc_index = index
	if amount > 1:
		for j in range(min(task_manager.missions.size(), questslots.size())):
			var questslot = questslots[j]
			var item = questslot.item
			var item_amount = questslot.item.amount
			if !questslots[j].item == null:
				if chosed_item == item:
					if item_amount == amount:
						show_item(questslot.itemStackGuib.inventorySlotb.item)
						await show_item(questslot.itemStackGuib.inventorySlotb.item)
						have_correct_amount = true
						break
						#has_key.emit()
						#
					#else:
						#print("no key")
						#no_key.emit()
				else:
					continue
					print("no method")

func insert_points(container_item : Statspoints):
	if container_item.point_type == "Stamppointmax":
		max_stamp_points += 1
		stamp_points += 1
	if container_item.point_type == "Heartpointmax":
		main_manager.maxHealth += 1
		main_manager.currentHealth == main_manager.maxHealth
	if container_item.point_type == "Coinmax":
		main_manager.coin_max += 25
	point_update.emit()

func finditem_amount(invslots, chosed_item, index, amount):
	var arg_has_key = true
	var arg_no_key = false
	npc_index = index
	if amount > 1:
		for j in range(min(SignalManager.inventoryb.invslots.size(), invslots.size())):

			if !invslots[j].itemStackGuib == null:
				var invslot = invslots[j]
				var item = invslot.itemStackGuib.inventorySlotb.item
				var item_amount = invslot.itemStackGuib.inventorySlotb.amount
				if chosed_item == item:
					if item_amount == amount:
						show_item(invslot.itemStackGuib.inventorySlotb.item)
						await show_item(invslot.itemStackGuib.inventorySlotb.item)
						have_correct_amount = true
						break
						#has_key.emit()
						#
					#else:
						#print("no key")
						#no_key.emit()
				else:
					continue
					print("no method")

	elif amount <= 1:
		for j in range(min(SignalManager.inventoryb.invslots.size(), invslots.size())):
			
			if !invslots[j].itemStackGuib == null:
				var invslot = invslots[j]
				var item = invslot.itemStackGuib.inventorySlotb.item
				var item_amount = invslot.itemStackGuib.inventorySlotb.amount
				if chosed_item == item:
					show_item(invslot.itemStackGuib.inventorySlotb.item)
					await show_item(invslot.itemStackGuib.inventorySlotb.item)
					have_correct_item = true
					break
					
				else:
					continue
					print("no method")
	can_emit_item = true

func find_key(invslots, key, index):
	var arg_has_key = true
	var arg_no_key = false
	door_index = index
	for j in range(min(SignalManager.inventoryb.invslots.size(), invslots.size())):
		var invslot = invslots[j]
		if !invslots[j].itemStackGuib == null:
			var secondary = invslot.itemStackGuib.inventorySlotb.item.scriptstr
			print("scr_key: ", scr_key)
			kscript = load(secondary).new()
			if kscript.has_method("key"):
				
				if invslot.itemStackGuib.inventorySlotb.item == key:
					print("has key")
					show_item(invslot.itemStackGuib.inventorySlotb.item)
					await show_item(invslot.itemStackGuib.inventorySlotb.item)
					have_correct_key = true
					return have_correct_key
					break
					#has_key.emit()
					#
				#else:
					#print("no key")
					#no_key.emit()
			else:
				return arg_no_key
				print("no method")
	can_emit_key = true
	#anotação: depois de quebrar esse loop faça ele abrir dialogo "no key"
	
func show_item(item):
	player.animation_player.play("new_item")
	player.showitem.texture = item.texture
	player.showitem.animation_player.play("surge_use")
	await player.animation_player.animation_finished
	
@onready var stats = get_tree().get_first_node_in_group("Stats")

signal sigload_equipstamp

func _ready() -> void:
	stats = get_tree().get_first_node_in_group("Stats")
	
	
	scene_loaded.connect(scene_load_function)
	stamp_equipped.connect(stamp_equippedfunc)
	stamp_unequipped.connect(stamp_unequippedfunc)
	world_loaded.connect(call_worldloaded)

var is_scene_loaded = false

func scene_load_function():
	is_scene_loaded = true

func call_worldloaded():
	can_update = true



var pos = []
#
#func save():
	#var signal_manager_variables = [stamp_points, max_stamp_points,main_manager.greed_equiped,main_manager.hleaf_equiped,main_manager.hatintime_equiped,main_manager.shadowdiver_equiped,main_manager.crimsonfury_equiped,main_manager.frozenheart_equiped,main_manager.ffemblem_equiped]
	#SaveSys.signalManager_dict[name] = signal_manager_variables
	#SaveSys.save_game(1)
	#its_saving.emit()
#
#
#
#
#
#func save_all_parameters():
	#pass
	##signal_manager_variables.append(signal_manager_variables)
#
#func load_parameters(update_parameters):
	#print("update_parameters: ", update_parameters)
	#if update_parameters != null:
		#if "SignalManager" in update_parameters:
			#print("isso: ", update_parameters["SignalManager"][0])
			#var signal_params = update_parameters["SignalManager"]
			##stamp_points = signal_params[0]
			#max_stamp_points = signal_params[1]
			#main_manager.greed_equiped = signal_params[2]
			#main_manager.hleaf_equiped = signal_params[3]
			#main_manager.hatintime_equiped = signal_params[4]
			#main_manager.shadowdiver_equiped = signal_params[5]
			#main_manager.crimsonfury_equiped = signal_params[6]
			#main_manager.frozenheart_equiped = signal_params[7]
			#main_manager.ffemblem_equiped = signal_params[8]
#
		#else:
			#print("A chave 'SignalManager' não existe em update_parameters.")
	#else:
		#print("update_parameters é nulo.")
#var inventoryequiped_array = []
#var inventorystamps_array = []
#var inventoryitems_array = []
#var inventoryitemsamount_array = []
#
#func save_inventory(slots):
	#for slot in inventoryb.invslots:
		#if slot.item != null:
			#inventoryitems_array.append(slot.item.name)
			#inventoryitemsamount_array.append(slot.amount)
			#print("item: ",slot.item.name)
			##inventoryequiped_array.append(PLAYER_INVENTORYC.stampslots[i])
			##inventoryequiped_array.append(PLAYER_INVENTORYC.stampslots[i].amount)
	#
	#for slot in inventory.slots:
		#if slot.item != null:
			#inventorystamps_array.append(slot.item.name)
			#print("stamp: ",slot.item.name)
			##inventoryequiped_array.append(PLAYER_INVENTORYC.stampslots[i])
			##inventoryequiped_array.append(PLAYER_INVENTORYC.stampslots[i].amount)
	#
	#for i in range(0,5):
		#
		#if slots[i].itemStackGuic != null:
			#inventoryequiped_array.append(slots[i].itemStackGuic.inventorySlotc.item.name)
			#print("item: ",slots[i].itemStackGuic.inventorySlotc.item.name)
			##inventoryequiped_array.append(PLAYER_INVENTORYC.stampslots[i])
			##inventoryequiped_array.append(PLAYER_INVENTORYC.stampslots[i].amount)
			#
	#SaveSys.equiped_stamps = inventoryequiped_array
	#SaveSys.inv_stamps = inventorystamps_array
	#SaveSys.inv_items = inventoryitems_array
	#SaveSys.inv_item_amounts = inventoryitemsamount_array
#
#
#
#func load_inventory(saved_items):
	#var index = 0
	#var array = []
	#for saved_item in saved_items:
		#for item in inv_dictionary.invseals:
			#if item.name == saved_item:
				##inventoryc.insert(item)
				#print("item: ", item.name)
				#print("saved item: ", saved_item)
				#if !array.has(item):
					#array.append(item)
	#for iteminarray in array:
		#emit_signal("sigload_equipstamp", iteminarray)
#
##@export var inventory : Inventory
#
#func load_stampsinventory(saved_items):
	#var index = 0
	#var array = []
	#for saved_item in saved_items:
		#for item in inv_dictionary.invseals:
			#if item.name == saved_item:
				##inventoryc.insert(item)
				#print("item: ", item.name)
				#print("saved item: ", saved_item)
				#if !array.has(item):
					#array.append(item)
	#for iteminarray in array:
		#inventory.insert(iteminarray)
		##emit_signal("sigload_equipstamp", iteminarray)
#
#func load_itemsinventory(saved_items, saved_amounts):
	#var index = 0
	#var array = []
	#var amount_array = []
	#for saved_item in saved_items:
		#for item in inv_dictionary.invsitems:
			#if item.name == saved_item:
				##inventoryc.insert(item)
				#print("item: ", item.name)
				#print("saved item: ", saved_item)
				#if !array.has(item):
					#array.append(item)
	#for iteminarray in array:
		#inventoryb.insert(iteminarray)
		#
	#for saved_amount in saved_amounts:
		#for item in inventoryb.invslots:
			#item.amount = saved_amount
#
#
#func load_equipstamp(slots: Array, sealslots: Array, currently_selected: int, inventoryc: Inventoryc, item):
	#var sealslot = sealslots
	#
	#for slot in slots:
		##var slotf = slots[currently_selected]
		#if !slot.isEmpty():
			#
				#print(slot.itemStackGui.inventorySlot.item)
				#if slot.itemStackGui.inventorySlot.item.name == item.name:
					#if slot.itemStackGui.inventorySlot.item.itemactivate == 0:
							#stamp_points -= item.stamp_points
							#slot.itemStackGui.inventorySlot.item.itemactivate = 1
							#inventoryc.insert(item)
							#
#
#
#func load_stamp_equippedfunc(slots: Array,currently_selected: int, inventory: Inventory, item):
		#for slot in slots:
			#if slot.itemStackGui != null:
				#if slot.itemStackGui.inventorySlot.item.name == item.name:
					#var secondary = slot.itemStackGui.inventorySlot.item.scriptstr
					#var itemscript = load(secondary).new()
					#print("stamp equip: ",slot.itemStackGui.inventorySlot.item.name)
				#
					#
					#secondary = slot.itemStackGui.inventorySlot.item.scriptstr
					#itemscript = load(secondary).new()
				#
				#
					#itemscript.activatestamp()
				##slots[currently_selected].modulateslot()
					#slot.itemStackGui.inventorySlot.amount = 0
					#print("é esse aqui ó -> ", slots[currently_selected].itemStackGui.inventorySlot.item.name, " num: ",currently_selected)
					#inventory.updated.emit()

@onready var inv_dictionary : InventoryDictionary = preload("res://inventory/Items/itemDictionary.tres")

# Variáveis globais de inventário
var inventoryequiped_array = []
var inventorystamps_array = []
var inventoryitems_array = []
var missions_array = []
var inventoryitemsamount_array = []

var currentsaveslot = null
var first_sceme = false
func set_saveslot():
	pass

# Funções para salvar e carregar os parâmetros do jogo
func save_all_parameters():
	var signal_manager_variables = [
		stamp_points, max_stamp_points,
		main_manager.greed_equiped, main_manager.hleaf_equiped,
		main_manager.hatintime_equiped, main_manager.shadowdiver_equiped,
		main_manager.crimsonfury_equiped, main_manager.frozenheart_equiped,
		main_manager.ffemblem_equiped
	]
	SaveSys.signalManager_dict["SignalManager"] = signal_manager_variables
	#SaveSys.save_game(1)  # Altere o número do slot se necessário
	#its_saving.emit()

func load_parameters(update_parameters):
	if update_parameters and "SignalManager" in update_parameters:
		var signal_params = update_parameters["SignalManager"]
		stamp_points = signal_params[0]
		max_stamp_points = signal_params[1]
		main_manager.greed_equiped = signal_params[2]
		main_manager.hleaf_equiped = signal_params[3]
		main_manager.hatintime_equiped = signal_params[4]
		main_manager.shadowdiver_equiped = signal_params[5]
		main_manager.crimsonfury_equiped = signal_params[6]
		main_manager.frozenheart_equiped = signal_params[7]
		main_manager.ffemblem_equiped = signal_params[8]
	else:
		print("Parâmetros de carregamento inválidos.")

# Funções para salvar o inventário
func save_inventory(slots):
	
	reset_inventory_arrays()
	
	for mission in task_manager.missions:
		if mission:
			missions_array.append(mission.resource_path)
		
			# Salva itens do inventário
	for slot in inventoryb.invslots:
		if slot.item:
			inventoryitems_array.append(slot.item.name)
			inventoryitemsamount_array.append(slot.amount)
	
	# Salva selos no inventário
	for slot in inventory.slots:
		if slot.item:
			inventorystamps_array.append(slot.item.name)
	
	# Salva itens equipados
	for i in range(slots.size()):
		if slots[i].itemStackGuic and slots[i].itemStackGuic.inventorySlotc.item:
			inventoryequiped_array.append(slots[i].itemStackGuic.inventorySlotc.item.name)

	# Atualiza os arrays de salvamento no SaveSys
	SaveSys.equiped_stamps = inventoryequiped_array
	SaveSys.inv_stamps = inventorystamps_array
	SaveSys.inv_items = inventoryitems_array
	SaveSys.inv_item_amounts = inventoryitemsamount_array
	SaveSys.missions_array = missions_array

func reset_inventory_arrays():
	missions_array.clear()
	inventoryequiped_array.clear()
	inventorystamps_array.clear()
	inventoryitems_array.clear()
	inventoryitemsamount_array.clear()

# Funções para carregar o inventário
func load_inventory(saved_items):
	var array = []
	for saved_item in saved_items:
		for item in inv_dictionary.invseals:
			if item.name == saved_item and !array.has(item):
				array.append(item)
	for item in array:
		emit_signal("sigload_equipstamp", item)

func load_stampsinventory(saved_items):
	for saved_item in saved_items:
		for item in inv_dictionary.invseals:
			if item.name == saved_item:
				inventory.insert(item)
	print("esse aqui stamps")

func load_itemsinventory(saved_items, saved_amounts):
	var index = 0
	for saved_item in saved_items:
		for item in inv_dictionary.invsitems:
			if item.name == saved_item:
				inventoryb.insert(item)
	
	# Define as quantidades dos itens
	for slot in inventoryb.invslots:
		if index < saved_amounts.size():
			slot.amount = saved_amounts[index]
			index += 1
	print("esse aqui items")

# Funções para carregar itens e selos equipados
func load_equipstamp(slots: Array, sealslots: Array, currently_selected: int, inventoryc: Inventoryc, item):
	for slot in slots:
		if slot.itemStackGui and slot.itemStackGui.inventorySlot.item.name == item.name:
			if slot.itemStackGui.inventorySlot.item.itemactivate == 0:
				stamp_points -= item.stamp_points
				slot.itemStackGui.inventorySlot.item.itemactivate = 1
				inventoryc.insert(item)
	print("esse aqui equipstamp")


func load_stamp_equippedfunc(slots: Array, currently_selected: int, inventory: Inventory, item):
	for slot in slots:
		if slot.itemStackGui and slot.itemStackGui.inventorySlot.item.name == item.name:
			var secondary = slot.itemStackGui.inventorySlot.item.scriptstr
			var itemscript = load(secondary).new()
			itemscript.activatestamp()
			slot.itemStackGui.inventorySlot.amount = 0
			inventory.updated.emit()
