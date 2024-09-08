extends Node


signal stamp_equipped
signal stamp_unequipped
signal just_equip
signal world_loaded

var can_update : bool = false

@onready var ItemStackGuiClass = preload("res://inventory/gui/itemStackGui.tscn")
@onready var ItemStackGuiClassb = preload("res://inventory/gui/itemStackGuib.tscn")
@onready var ItemStackGuiClassc = preload("res://inventory/gui/itemStackGuic.tscn")
@onready var inventory: Inventory = preload("res://inventory/PlayerInventory.tres")
@onready var inventoryb: Inventoryb = preload("res://inventory/PlayerInventoryb.tres")
@onready var inventoryc: Inventoryc = preload("res://inventory/PlayerInventoryc.tres")

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

func _ready() -> void:
	stamp_equipped.connect(stamp_equippedfunc)
	stamp_unequipped.connect(stamp_unequippedfunc)
	world_loaded.connect(call_worldloaded)

func call_worldloaded():
	can_update = true
