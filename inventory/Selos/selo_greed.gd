class_name GreedStamp extends InventoryItem

@export var coin_multiplier: int = 2
@export var manager = preload("res://inventory/Moedas/coinmanager.tres")
func use(player: Player) -> void:
	print("useitem")
func activatestamp():
	print("foi")
	manager.coin_mult = coin_multiplier
	print(manager.coin_mult)
func deactivatestamp():
	print("desfoi")
	manager.coin_mult = 1
	print(manager.coin_mult)
