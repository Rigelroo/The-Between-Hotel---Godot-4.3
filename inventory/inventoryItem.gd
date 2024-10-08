extends Resource

class_name InventoryItem

@export var name: String = ""
@export var texture: Texture2D
@export var equipedtexture : String = ""
@export var textureaux : String = ""
@export var maxAmountInStack: int = 2
@export var max_amount : int
@export var showname : String = ""
@export var description : String = ""

@export var stamp_points : int = 0
@export var color : Color
@export var color_x : float
@export var color_y : float
@export var color_z : float

@export var first_item : int = 0
#if itemactivate = 0 : false
#if itemactivate = 1 : true
@export var itemactivate : int = 0
@export var scriptstr : String = ""
var itemscript = null



	
func item_isactive():
	if itemactivate == 0:
		print("not activated")
	if itemactivate == 1:
		print("activated")
		
	
