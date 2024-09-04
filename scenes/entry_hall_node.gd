extends Node2D

class_name World
var dead : bool = false
#@onready var canvas : CanvasLayer = $CanvasLayer

@export var objplayer : Player
@export var splashw : SplashWater

@onready var inventory = $PausemenuLayer.inventory
@onready var player = get_tree().get_first_node_in_group("Player")
@onready var gameover_manager = get_tree().get_first_node_in_group("Gameover")
@onready var hudbar = $Statslayer/Statsbar

var canOpen_inventory : bool = true

#@onready var hud : HudBar = $CanvasLayer/Hudbar
@export var inv_dictionary : InventoryDictionary
@onready var item_index = inv_dictionary.invsitems
@onready var stamp_index = inv_dictionary.invseals

@export var color_x : float
@export var color_y : float
@export var color_z : float
var splashposition 
enum TerrainType {
	WATER1 = 1,
	WATER2 = 2,
	GROUND = 3
}

signal loaded()
var death_scene: String = "res://Tests/deadreplacer.tscn"
@export_file("*.tscn") var next_scene: String
@onready var manager : MainManager = preload("res://Global/Mainmanager.tres")


func load_scene() -> void:
	manager.loaded.emit()
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	
	player.set_idle()
	manager.inventoryopened.connect(_on_inventory_gui_opened)
	manager.inventoryclosed.connect(_on_inventory_gui_closed)
	manager.loadscene.connect(load_scene)
	objplayer.death.connect(death)
	splashw.Vaifundo.connect(create_splash)
	splashw.Desvaifundo.connect(dont_create_splash)

	$PausemenuLayer.inventory.readyclose()
	
	Dialogic.signal_event.connect(_on_dialogic_signal)
	
	#canvas.global_position = player.global_position
func activate():
	if splashw.can_create:
		splashw.Vaifundo.emit()
	if !splashw.can_create:
		splashw.Desvaifundo.emit()
		
func create_splash():
	instance_object()
	print("shuaaa")
	splashw.can_create = false
	
func dont_create_splash():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process_tilemap(body: Node2D, body_RID: RID) -> void:
	pass
func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("Transition"):
		#SceneManager.transition_to(next_scene)
	#
	if splashw.can_create == true:
		activate()
		

func _on_inventory_gui_closed() -> void:
	#self.get_tree().paused = false
	pass

func _on_inventory_gui_opened() -> void:
	#self.get_tree().paused = true
	pass


func collect_item(inventoryb: Inventoryb):
	inventoryb.insert(item_index[Dialogic.VAR.index])
	queue_free()
	
	
func collect_stamp(inventory: Inventory):
	inventory.insert(stamp_index[Dialogic.VAR.index])
	queue_free()


func death():
	gameover_manager.activate()
	


var splashinst = preload("res://objects/watersplash.tscn")

func instance_object():
	
	var new_splash = splashinst.instantiate()
	var parent = self.get_parent()
	
		# Add the new node to your scene's node tree.
	parent.add_child(new_splash)

		# Now change stuff related to the scene structure (like position)
	#new_splash.global_position = objplayer.splashdec.global_position
	new_splash.modulate = Color(color_x, color_y, color_z)
	print(color_x,color_y,color_z)
	new_splash.position.y = splashposition
	new_splash.position.x = objplayer.position.x
	new_splash.scale.x = 0.255
	new_splash.scale.y = 0.255
	
	
	
	#Call the instance_object() function when you have to create objects. You can also set the position of the object by doing something like: object.position = Vector2(0,0) which will create the object at position(0,0).





# Called every frame. 'delta' is the elapsed time since the previous frame.






# Called when the node enters the scene tree for the first time.
#
#@onready var label = $Control2/Label
#@onready var gameTimer = $Control2/Timer
#
#func _physics_process(delta):
	#var texttimer = str(time_to_minutes_secs_mili(gameTimer.get_time_left()))
	#label.call_deferred("set_text", texttimer)
#
#func time_to_minutes_secs_mili(time : float):
	#var mins = int(time) / 60
	#time -= mins * 60
	#var secs = int(time)
	#var mili = int((time - int(time)) * 100)
	#return str(mins) + ":" + str(secs)


func _input(event):
	if event.is_action_pressed("menu_inventory"):
		if canOpen_inventory:
			if inventory.isOpen:
				hudbar.visible = true
				inventory.close()
			else:
				inventory.open()
				hudbar.visible = false
	else: pass
	
func _on_dialogic_signal(argument:String):
	if argument == "deactivate_movement":
		print("Deactivate Movement!")
		canOpen_inventory = false
	if argument == "reactivate_movement":
		print("Reactivate Movement!")
		canOpen_inventory = true

var use_milliseconds : bool
