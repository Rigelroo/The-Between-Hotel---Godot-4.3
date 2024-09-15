extends Resource

class_name InventoryItemb

@export var name: String = ""
@export_enum("Key_item", "Task_item", "Normal_item") var Item_type: String
@export var texture: Texture2D
@export var maxAmountInStack: int = 2
@export var max_amount: int
@export var showname : String = ""
@export var description : String = ""
@export var color : Color
@export var color_x : float
@export var color_y : float
@export var color_z : float
@export var first_item : int = 0
@export_file("*.gd") var scriptstr : String
