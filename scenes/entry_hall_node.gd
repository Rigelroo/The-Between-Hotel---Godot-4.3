extends Node2D


class_name World
var dead : bool = false
#@onready var canvas : CanvasLayer = $CanvasLayer

signal scene_ready

@export_file("*.mp3") var background_music_array : Array[String]

@export var objplayer : Player
@export var splashw : SplashWater
@export var scene_name : String
@export var nome_cena : String
@export var player_scale : float = 1
@onready var inventory = $PausemenuLayer.inventory
@onready var player = get_tree().get_first_node_in_group("Player")
@onready var stats = get_tree().get_first_node_in_group("Stats")
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

signal just_equip

func _physics_process(delta: float) -> void:
	pass
	#if Input.is_action_just_pressed("Attack") && inventory.number == 1:
		#SignalManager.just_equip.emit()

func take_screenshot(file_path: String = "user://screenshot.png") -> void:
	var viewport = get_viewport()
	var image = viewport.get_texture().get_image()
	#image.flip_y()  # Flipa a imagem no eixo Y para corrigir a orientação
	image.save_png(file_path)
	print("Screenshot salva em:", file_path)

func save_slot_screenshot(slot: int) -> void:
	var file_path = "user://slot%s_screenshot.png" % str(slot)
	take_screenshot(file_path)
	print("Screenshot salva para o slot %s" % slot)



func set_player_speed():
	player_scale = objplayer.global_scale.x
	objplayer.SPEED = 80 * player_scale 
	objplayer.JUMP_VELOCITY = -95.0 * player_scale
	objplayer.dash_speed = 190 * player_scale

func load_scene() -> void:
	manager.loaded.emit()
	
func background_music():
	if !background_music_array.is_empty():
		var sound_load = load(background_music_array[0])
		GlobalAudioStreamPlayer.set_stream(sound_load)
		GlobalAudioStreamPlayer.play()


func some_function():
	if SignalManager.is_inside_tree():
		# Execute a lógica
		pass
	else:
		print("SignalManager não está acessível.")
# Called when the node enters the scene tree for the first time.


func load_one_time():
	if SignalManager.first_sceme:
		SaveSys.load_game(SignalManager.currentsaveslot, self)
		SignalManager.first_sceme = false

func _ready() -> void:
	SignalManager.mouse_visible = false
	SignalManager.player = objplayer
	player = objplayer
	#SignalManager.its_saving.connect(save_scenestate)
	load_one_time()
	
	some_function()
	background_music()
	set_player_speed()
	SignalManager.world_loaded.emit()
	
	player.set_idle()
	SignalManager.inventoryopened.connect(_on_inventory_gui_opened)
	SignalManager.inventoryclosed.connect(_on_inventory_gui_closed)
	manager.loadscene.connect(load_scene)
	objplayer.death.connect(death)
	splashw.Vaifundo.connect(create_splash)
	splashw.Desvaifundo.connect(dont_create_splash)

	$PausemenuLayer.inventory.readyclose()
	
	#load_scenestate()
	
	Dialogic.signal_event.connect(_on_dialogic_signal)
	scene_readyvar = true
	#SignalManager.scene_loaded.emit()
	#canvas.global_position = player.global_position

var scene_readyvar = false


#func save_scenestate():
	#for child in get_children():
		#if child.has_method("save"):
			#child.save()
#
#func load_scenestate():
	#for child in get_children():
		#if child.has_method("load_player_state"):
			#child.load_player_state()


#func save_scenestate():
	#for child in self.get_children():
		#if child.has_method("save"):
			#child.save()

#func load_scenestate():
	#for child in self.get_children():
		#if child.has_method("load_player_state"):
			#child.load_player_state()

func loadscene():
	if scene_readyvar:
		SignalManager.scene_loaded.emit()


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

func _process(_delta: float) -> void:
	pass
	#if Input.is_action_just_pressed("Save"):
		#if SignalManager.currentsaveslot != null:
			#save_slot_screenshot(SignalManager.currentsaveslot)
			#SignalManager.its_saving.emit()
			#SaveSys.save_game(SignalManager.currentsaveslot)
		#elif SignalManager.currentsaveslot == null:
			#SignalManager.currentsaveslot = 0
			#save_slot_screenshot(SignalManager.currentsaveslot)
			#SignalManager.its_saving.emit()
			#SaveSys.save_game(SignalManager.currentsaveslot)


		#load_scenestate()
	
	if splashw.can_create == true:
		activate()
		

func _on_inventory_gui_closed() -> void:
	self.get_tree().paused = false
	pass

func _on_inventory_gui_opened() -> void:
	self.get_tree().paused = true
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


#func _input(event):
	#if event.is_action_pressed("menu_inventory"):
		#if canOpen_inventory:
			#if inventory.isOpen:
				#hudbar.visible = true
				#inventory.close()
			#else:
				#inventory.open()
				#hudbar.visible = false
	#else: pass
	#
func _on_dialogic_signal(argument:String):
	if argument == "deactivate_movement":
		print("Deactivate Movement!")
		canOpen_inventory = false
	if argument == "reactivate_movement":
		print("Reactivate Movement!")
		canOpen_inventory = true

var use_milliseconds : bool
