extends Button
#
#@onready var background_sprite : Sprite2D = $background
#@onready var item_stack_gui : ItemStackGui = $CenterContainer/Panel
#
#func update_to_slot(slot: InventorySlot) -> void:
	#if !slot.item:
		#item_stack_gui.visible = false
		#background_sprite.frame = 0
		#return
		#
	#item_stack_gui.inventorySlot = slot
	#item_stack_gui.update()
	#item_stack_gui.visible = true
	#
	#background_sprite.frame = 0

@onready var backgroundSprite: Sprite2D = $background
@onready var container: CenterContainer = $CenterContainer

@onready var inventory = preload("res://inventory/PlayerInventory.tres")

var itemStackGui: ItemStackGui
var index: int


func insert(isg: ItemStackGui):
	itemStackGui = isg
	backgroundSprite.frame = 0
	container.add_child(itemStackGui)
	
	if !itemStackGui.inventorySlot || inventory.slots[index] == itemStackGui.inventorySlot:
		return
	
	inventory.insertSlot(index, itemStackGui.inventorySlot)

func takeItem():
	var item = itemStackGui
	
	inventory.removeSlot(itemStackGui.inventorySlot)
	
	container.remove_child(itemStackGui)
	itemStackGui = null
	backgroundSprite.frame = 0
	
	return item

func isEmpty():
	return !itemStackGui

func activate_use():
	itemStackGui.inventorySlot.inventoryItem.use()
