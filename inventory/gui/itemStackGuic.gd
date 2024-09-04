extends Panel

class_name ItemStackGuic

var sealSprite: Sprite2D 
var amountLabel: Label
@export var inv: Inventoryc
var inventorySlotc: InventorySlotc

func update():
	sealSprite = $Seal
	amountLabel = $Label
	if !inventorySlotc  || !inventorySlotc.item:        return
	
	sealSprite.visible = true
	sealSprite.texture = inventorySlotc.item.texture
	
	if inventorySlotc.amount > 1:
		amountLabel.visible = true
		amountLabel.text = str(inventorySlotc.amount)
	else:
		amountLabel.visible = false
