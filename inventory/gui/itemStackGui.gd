extends Panel

class_name ItemStackGui


@onready var sealSprite: Sprite2D = $Seal
@onready var amountLabel: Label = $Label
@export var inv: Inventory
var inventorySlot: InventorySlot
@onready var oldModulate = sealSprite.modulate

func update():
	if !inventorySlot  || !inventorySlot.item:        return
	
	sealSprite.visible = true
	sealSprite.texture = inventorySlot.item.texture
	
	oldModulate = sealSprite.modulate
	if inventorySlot.amount == 0:
		#sealSprite.modulate = Color(0.43,0.37,0.75)
		
		sealSprite.modulate = Color(0.43,0.37,0.75)
		print("modulate")

	if inventorySlot.amount == 1:
		sealSprite.modulate = Color(1,1,1)
		print("oldmodulate")
	
	if inventorySlot.amount > 1:
		
		amountLabel.visible = true
		amountLabel.text = str(inventorySlot.amount)
	else:
		amountLabel.visible = false
