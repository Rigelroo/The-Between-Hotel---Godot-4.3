class_name FireflyStamp extends InventoryItem
signal Equiped 


var hleaf_equiped : bool = false
@export var manager = preload("res://Global/Mainmanager.tres")
@export var coin_multiplier: int = 2



func use(player: Player) -> void:
	print("useitem")
func activatestamp():
	Equiped.emit()
	manager.ffemblem_equiped = true
	print("ht foi")
func deactivatestamp():
	manager.ffemblem_equiped = false
	print("ht desfoi")
	#manager.no_ffemblem.emit()
	
