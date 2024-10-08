extends Resource

class_name Statspoints

@export var name: String = ""
@export var texture: Texture2D

@export var showname : String = ""
@export_enum("Heartpointmax", "Stamppointmax", "Coinmax", "Stampcontainer" ) var point_type : String


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
