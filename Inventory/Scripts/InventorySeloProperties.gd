extends InventoryItem

class_name StampProperties

@export var test := "oi moço"
@export_subgroup("Essence Things")
@export_range(0.0, 10.0, 0.1) var essence_cost_dropper := 0.0
@export var essence_cost := 0.0
@export_subgroup("Stamp Shenanigans")
@export_enum("Emblema","Tralha","Brinquedo") var item_type : String
@export var stamp_points : int = 0

func use():
	
	return test
