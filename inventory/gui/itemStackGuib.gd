extends Panel

class_name ItemStackGuib

@onready var sealSprite: Sprite2D = $Seal
@onready var amountLabel: Label = $Label

var inventorySlotb: InventorySlotb

func update():
	if !inventorySlotb  || !inventorySlotb.item:        return
	
	sealSprite.visible = true
	sealSprite.texture = inventorySlotb.item.texture
	
	if inventorySlotb.amount > 1:
		amountLabel.visible = true
		amountLabel.text = str(inventorySlotb.amount)
	else:
		amountLabel.visible = false
