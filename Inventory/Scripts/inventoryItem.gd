extends Resource

class_name InventoryItem

@export var name: String = ""
@export var texture: Texture2D
@export var color : Color
@export var maxAmountInStack: int = 2
@export var max_amount : int
@export var showname : String = ""
@export var description : String = ""
@export_subgroup("Activation Things")
@export var scriptstr : String = ""
@export var first_item : int = 0
@export var itemactivate : int = 0
#@export_enum("Emblema","Tralha","Brinquedo") var item_type : Array[int]
@export_category("Stamp Shenanigans")
@export_enum("Emblema","Tralha","Brinquedo") var item_type : String
@export var stamp_points : int = 0
@export_subgroup("Essence Things")
@export_range(0.0, 10.0, 0.1) var essence_cost_dropper := 0.0
@export var essence_cost := 0.0

var itemscript = null

func use():
	print("use ", str(self.name))

func activate():
	print("activate ", str(self.name))

func deactivate():
	print("deactivate ", str(self.name))

func item_update():
	pass

func item_isactive():
	if itemactivate == 0:
		print("not activated")
	if itemactivate == 1:
		print("activated")
		
	
