extends Button

@onready var backgroundSprite: Sprite2D = $background
@onready var container: CenterContainer = $CenterContainer

@onready var inventoryc = preload("res://inventory/PlayerInventoryc.tres")

var itemStackGuic: ItemStackGuic
var index: int


func insert(isg: ItemStackGuic):
	itemStackGuic = isg
	backgroundSprite.frame = 0
	container.add_child(itemStackGuic)
	
	if !itemStackGuic.inventorySlotc || inventoryc.stampslots[index] == itemStackGuic.inventorySlotc:
		return
	
	inventoryc.insertSlot(index, itemStackGuic.inventorySlotc)

func takeItem():
	var item = itemStackGuic
	
	inventoryc.removeSlot(itemStackGuic.inventorySlotc)
	
	container.remove_child(itemStackGuic)
	itemStackGuic = null
	backgroundSprite.frame = 0
	
	return item

func isEmpty():
	return !itemStackGuic
	
func clear() -> void:
	if itemStackGuic:
		container.remove_child(itemStackGuic)
		itemStackGuic = null
	backgroundSprite.frame = 0
