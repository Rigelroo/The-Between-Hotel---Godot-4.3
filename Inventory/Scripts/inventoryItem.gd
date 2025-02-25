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
@export var first_item := false
#@export_enum("Emblema","Tralha","Brinquedo") var item_type : Array[int]



var itemscript = null

func use():
	print("use ", str(self.name))

func activate():
	print("activate ", str(self.name))

func deactivate():
	print("deactivate ", str(self.name))

func item_update():
	pass
