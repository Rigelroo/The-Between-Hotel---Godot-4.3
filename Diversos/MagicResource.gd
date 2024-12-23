extends Resource

class_name MagicResource

@export var textureicon: Texture2D
@export var item: InventoryItem
@export var name: String
@export var ink_cost: int
@export var cooldown : float
@export var duration : float
@export_file("*.tscn") var particles_scene_str : String
@export_file("*.gd") var magic_script_str : String
func use():
	pass
