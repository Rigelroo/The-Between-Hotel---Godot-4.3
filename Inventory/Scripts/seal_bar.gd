extends Control

signal opened
signal closed

var isOpen: bool = false

@onready var ItemStackGuiClass = preload("res://inventory/gui/itemStackGui.tscn")
@onready var ItemStackGuiClassb = preload("res://inventory/gui/itemStackGuib.tscn")

@onready var inventory: Inventoryc = preload("res://inventory/PlayerInventoryc.tres")
@onready var inventoryb: Inventoryb = preload("res://inventory/PlayerInventoryb.tres")
@onready var slots: Array = $Control.get_children()
#@onready var slots: Array = $TabContainer/Selos/Panel/SealBar.get_children()

@onready var Selos = $"TabContainer/Selos"
@onready var tab = $"TabContainer"

@onready var nameLabel = $TabContainer/Selos/NameLabel
@onready var descLabel = $TabContainer/Selos/Description
@onready var showSprite = $TabContainer/Selos/ShowSprite
@export var number = 0

var itemInHand: ItemStackGui
var currently_selected: int = 0
func _ready():
	connectSlots()
	inventory.updated.connect(update)
	print("first position",number)
	update()

func update():
	for i in range(min(inventory.slots.size(), slots.size())):
		var inventorySlot: InventorySlot = inventory.slots[i]
		
		if !inventorySlot.item: continue
		
		var itemStackGui: ItemStackGui = slots[i].itemStackGui
		
		if !itemStackGui:
			itemStackGui = ItemStackGuiClass.instantiate()
			slots[i].insert(itemStackGui)
		itemStackGui.inventorySlot = inventorySlot
		itemStackGui.update()


func open():
	tab.current_tab = 0
	visible = true
	isOpen = true
	opened.emit()

func close():
	visible = false
	isOpen = false
	closed.emit()

func onSlotClicked(slot):
	print("clico")
	if !slot.isEmpty():
		pass
	if slot.isEmpty():
		if !itemInHand: return
		
		insertItemInSlot(slot)
		return
		
	if !itemInHand:
		takeItemFromSlot(slot)
		return
	if slot.itemStackGui.inventorySlot.item.name == itemInHand.inventorySlot.item.name:
		
		stackItems(slot)
		return
		
	swapItems(slot)

func takeItemFromSlot(slot):
	itemInHand = slot.takeItem()
	add_child(itemInHand)
	updateItemInHand()

func insertItemInSlot(slot):
	var item = itemInHand
	
	remove_child(itemInHand)
	itemInHand = null
	
	slot.insert(item)

func swapItems(slot):
	var tempItem = slot.takeItem()
	insertItemInSlot(slot)
	itemInHand = tempItem
	add_child(itemInHand)
	updateItemInHand()
	
func stackItems(slot):
	var slotItem: ItemStackGui = slot.itemStackGui
	var maxAmount = slotItem.inventorySlot.item.maxAmountInStack
	var totalAmount = slotItem.inventorySlot.amount + itemInHand.inventorySlot.amount
	if slotItem.inventorySlot.amount == maxAmount:
		swapItems(slot)
		return
	if totalAmount <= maxAmount:
		slotItem.inventorySlot.amount = totalAmount
		remove_child(itemInHand)
		itemInHand = null
	else:
		slotItem.inventorySlot.amount = maxAmount
		itemInHand.inventorySlot.amount = totalAmount - maxAmount
	
	slotItem.update()
	if itemInHand: itemInHand.update()
	

func connectSlots():
	for i in range(slots.size()):
		var slot = slots[i]
		slot.index = i
		
		var callable = Callable(onSlotClicked)
		callable = callable.bind(slot)
		slot.pressed.connect(callable)

func updateItemInHand():
	if !itemInHand: return
	itemInHand.global_position = get_global_mouse_position() - itemInHand.size / 2
