extends HBoxContainer

class_name BerserkBar

signal update

@export var points_index: int

@onready var maxpoints: Array = %HBoxContainer.get_children()
@onready var maxpoints_num : int = %HBoxContainer.get_child_count()
@export var amount = 3
@export var current_fullness = 1
@onready var pointscene = preload("res://scenes/entities/player/Systems/middlepointcontainer.tscn")
@export var manager : MainManager
@onready var inv_manager : InventoryManager
@onready var player = get_tree().get_first_node_in_group("Player")

func _process(delta: float) -> void:
	if manager.crimsonfury_equiped:
		self.visible = true
		
	elif !manager.crimsonfury_equiped:
		self.visible = false
		player.currentFurypoints = 0
		

func _on_inventory_gui_opened():
	self.visible = false
func _on_inventory_gui_closed():
	self.visible = true

func _ready() -> void:
	SignalManager.world_loaded.connect(world_ready)

func world_ready() -> void:
	manager.inventoryopened.connect(_on_inventory_gui_opened)
	manager.inventoryclosed.connect(_on_inventory_gui_closed)
	maxpoints.max()
	print(maxpoints_num)
	set_max_points(2)
	show_current_points(player.currentFurypoints)
	player.healthChanged.connect(show_current_points)
	player.temporary.connect(temporaryf)
	set_points()
	
	print(%HBoxContainer.get_child_count())

func temporaryf():
	print(player.currentFurypoints)
func show_current_points(current_points: int):
	var points = get_children()
	
	for i in range(current_points):
		points[i].update_points(true)
	
	for i in range(current_points, points.size()):
		points[i].update_points(false)
		

func set_max_points(max: int):
	for i in range(max):
		var new_point = pointscene.instantiate()
		%"2Middlepointcontainer".add_sibling(new_point, true)
		#%HBoxContainer.add_child(new_point)
		print("coin: ", new_point.name)
		print(maxpoints)
		
		#%HBoxContainer.add_child(%Middlepointcontainer)
	pass
var y : int = -1
func set_fullness():
	for i in range(points_index):
	#for i in range(current_fullness):
		maxpoints[i].animationsprite.frame = 1
		print(maxpoints[i].animationsprite.frame)
		print("current_fullness: ",current_fullness)
		#%HBoxContainer.add_child(%Middlepointcontainer)
	pass
	

func set_emptyness():
	#filho tu tem que pegar esse negoço setar o valor do slots vazios
	#basicamente o contrario do set_fullness
	pass
	#for i in range(points_index):
	##for i in range(current_fullness):
		#maxpoints[i].animationsprite.frame = 1
		#print(maxpoints[i].animationsprite.frame)
		#print("current_fullness: ",current_fullness)
		##%HBoxContainer.add_child(%Middlepointcontainer)
	#pass
func set_points():
	pass
	#for point in maxpoints:
		#var fullpoints = maxpoints[points_index]
		#if point.get_name() == "Firstpointcontainer":
			#print("ehr")
			#


#func _on_update() -> void:
	#var updatecontainer: Array = %HBoxContainer.get_children()
	#maxpoints = updatecontainer
	#set_fullness()
	
