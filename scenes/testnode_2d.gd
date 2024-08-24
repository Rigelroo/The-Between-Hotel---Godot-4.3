extends Node2D

class_name Test2D

#@onready var canvas : CanvasLayer = $CanvasLayer
#@onready var player = $Player/Camera2D

@export var inv_dictionary : InventoryDictionary
@onready var item_index = inv_dictionary.invsitems
@onready var stamp_index = inv_dictionary.invseals

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#canvas.global_position = player.global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_inventory_gui_closed() -> void:
	get_tree().paused = false


func _on_inventory_gui_opened() -> void:
	get_tree().paused = true


func collect_item(inventoryb: Inventoryb):
	inventoryb.insert(item_index[Dialogic.VAR.index])
	queue_free()
	
func collect_stamp(inventory: Inventory):
	inventory.insert(stamp_index[Dialogic.VAR.index])
	queue_free()
