extends InventoryItem
class_name HatStamps


var hleaf_equiped : bool = false
@export var manager = preload("res://Global/Mainmanager.tres")
@export var coin_multiplier: int = 2



func use(player: Player) -> void:
	print("useitem")
func activatestamp():
	
	manager.hatintime_equiped = true
	print("ht foi")
func deactivatestamp():
	manager.hatintime_equiped = false
	print("ht desfoi")
	manager.no_hats.emit()
	
