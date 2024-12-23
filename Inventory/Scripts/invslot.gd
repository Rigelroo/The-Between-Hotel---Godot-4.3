extends Button

@onready var backgroundSprite: AnimatedSprite2D = $background
@onready var container: CenterContainer = $CenterContainer

@onready var inventoryb = preload("res://inventory/PlayerInventoryb.tres")

var itemStackGuib: ItemStackGuib
var index: int
var noitemtexture = preload("res://inventory/slot inventario - NoItem.png")
var hasitemtexture = preload("res://inventory/slot inventario.png")


func insert(isgb: ItemStackGuib):
	itemStackGuib = isgb
	backgroundSprite.play("default")
	container.add_child(itemStackGuib)
	
	if !itemStackGuib.inventorySlotb || inventoryb.invslots[index] == itemStackGuib.inventorySlotb:
		backgroundSprite.play("no_item")
		return
	
	inventoryb.insertSlotb(index, itemStackGuib.inventorySlotb)

func takeItem():
	var item = itemStackGuib
	
	inventoryb.removeSlot(itemStackGuib.inventorySlotb)
	
	container.remove_child(itemStackGuib)
	itemStackGuib = null
	backgroundSprite.play("no_item")
	
	return item

func isEmpty():
	return !itemStackGuib
	
func clear() -> void:
	if itemStackGuib:
		container.remove_child(itemStackGuib)
		itemStackGuib = null
	backgroundSprite.frame = 0
