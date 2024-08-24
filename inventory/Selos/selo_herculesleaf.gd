class_name HerculesLeafStamp extends InventoryItem

var hleaf_equiped : bool = false
@export var manager = preload("res://inventory/Moedas/coinmanager.tres")
@export var coin_multiplier: int = 2


func use(player: Player) -> void:
	print("useitem")
func activatestamp():
	
	manager.hleaf_equiped = true
	print("hf foi")
func deactivatestamp():
	manager.hleaf_equiped = false
	print("hf desfoi")
	
