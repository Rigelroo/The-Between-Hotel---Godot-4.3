class_name GreedStamp extends InventoryItem

@export var coin_multiplier: int = 2

func use(_player: Player) -> void:
	print("useitem")
func activatestamp():
	print("foi")
	SignalManager.greed_equiped = true
	print("greed_equiped: ", SignalManager.greed_equiped)
	#manager.coin_mult = coin_multiplier
	
func deactivatestamp():
	print("desfoi")
	SignalManager.greed_equiped = false
	#manager.coin_mult = 1
