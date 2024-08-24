extends Panel

class_name ItemStackGuic

@onready var sealSprite: Sprite2D = $Seal
@onready var amountLabel: Label = $Label

var inventorySlotc: InventorySlotc

func update():
	if !inventorySlotc  || !inventorySlotc.item:        return
	
	sealSprite.visible = true
	sealSprite.texture = inventorySlotc.item.texture
	
	if inventorySlotc.amount > 1:
		amountLabel.visible = true
		amountLabel.text = str(inventorySlotc.amount)
	else:
		amountLabel.visible = false
