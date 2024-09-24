extends Node


signal stamp_equipped
signal stamp_unequipped
signal just_equip
signal world_loaded
signal magic_changed

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

var can_update : bool = false


var have_correct_key = false
var have_correct_item = false
var have_correct_amount = false

var door_index = false
var npc_index = false

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
var player = null

func equipstamp(slots: Array, sealslots: Array, currently_selected: int, inventoryc: Inventoryc):
	var sealslot = sealslots
	var slotf = slots[currently_selected]
	if !slotf.isEmpty():
		inventoryc.insert(slotf.itemStackGui.inventorySlot.item)
		print(slotf.itemStackGui.inventorySlot.item)
		if slotf.itemStackGui.inventorySlot.item.itemactivate == 0:
			slotf.itemStackGui.inventorySlot.item.itemactivate = 1
		elif slotf.itemStackGui.inventorySlot.item.itemactivate == 1:
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
	player = get_tree().get_first_node_in_group("Player")
	var arg_has_key = true
	var arg_no_key = false
	npc_index = index
	if amount > 1:
		for j in range(min(SignalManager.task_manager.missions.size(), questslots.size())):
			var questslot = questslots[j]
			var item = questslot.itemStackGuib.inventorySlotb.item
			var item_amount = questslot.itemStackGuib.inventorySlotb.item.amount
			if !questslots[j].itemStackGuib == null:
				if chosed_item == item:
					if item_amount == amount:
						show_item(player, questslot.itemStackGuib.inventorySlotb.item)
						await show_item(player, questslot.itemStackGuib.inventorySlotb.item)
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


func finditem_amount(invslots, chosed_item, index, amount, item_type):
	player = get_tree().get_first_node_in_group("Player")
	var arg_has_key = true
	var arg_no_key = false
	npc_index = index
	if amount > 1:
		for j in range(min(SignalManager.inventoryb.invslots.size(), invslots.size())):
			var invslot = invslots[j]
			var item = invslot.itemStackGuib.inventorySlotb.item
			var item_amount = invslot.itemStackGuib.inventorySlotb.item.amount
			if !invslots[j].itemStackGuib == null:
				if chosed_item == item:
					if item_amount == amount:
						show_item(player, invslot.itemStackGuib.inventorySlotb.item)
						await show_item(player, invslot.itemStackGuib.inventorySlotb.item)
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
			var invslot = invslots[j]
			var item = invslot.itemStackGuib.inventorySlotb.item
			var item_amount = invslot.itemStackGuib.inventorySlotb.item.amount
			if !invslots[j].itemStackGuib == null:
				if chosed_item == item:
					show_item(player, invslot.itemStackGuib.inventorySlotb.item)
					await show_item(player, invslot.itemStackGuib.inventorySlotb.item)
					have_correct_item = true
					break
					
				else:
					continue
					print("no method")
	can_emit_item = true

func find_key(invslots, key, index):
	player = get_tree().get_first_node_in_group("Player")
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
					show_item(player, invslot.itemStackGuib.inventorySlotb.item)
					await show_item(player, invslot.itemStackGuib.inventorySlotb.item)
					have_correct_key = true
					break
					#has_key.emit()
					#
				#else:
					#print("no key")
					#no_key.emit()
			else:
				continue
				print("no method")
	can_emit_key = true
	#anotação: depois de quebrar esse loop faça ele abrir dialogo "no key"
	
func show_item(player: Player, item):
	player.animation_player.play("new_item")
	player.showitem.texture = item.texture
	player.showitem.animation_player.play("surge_use")
	await player.animation_player.animation_finished
	

func _ready() -> void:
	stamp_equipped.connect(stamp_equippedfunc)
	stamp_unequipped.connect(stamp_unequippedfunc)
	world_loaded.connect(call_worldloaded)

func call_worldloaded():
	can_update = true
