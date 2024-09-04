extends Panel

class_name ItemStackGuib

var sealSprite: Sprite2D
var amountLabel: Label

var inventorySlotb: InventorySlotb

func update():
	sealSprite = $Seal
	amountLabel = $Label
	if !inventorySlotb  || !inventorySlotb.item:        return
	
	sealSprite.visible = true
	sealSprite.texture = inventorySlotb.item.texture
	
	if inventorySlotb.amount > 1:
		amountLabel.visible = true
		amountLabel.text = str(inventorySlotb.amount)
	else:
		amountLabel.visible = false
