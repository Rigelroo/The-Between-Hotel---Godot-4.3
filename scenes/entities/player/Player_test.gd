#extends CharacterBody2D
#
#class_name Player
#
#@export var showitem : Sprite2D
#@export var ghost_node : PackedScene
#@onready var ghost_timer = $GhostTimer
#@onready var particles = $GPUParticles2D
#@export var can_interact = false
#@export var can_move = true
#@export var can_move_si = true
#@export var camera : Camera2D
#
#@export var inventory : Inventory
#@export var inventoryb : Inventoryb
#@export var inventoryc : Inventoryc
#@export var inv_dictionary : InventoryDictionary
#@export var manager : CoinManager
#@export var hudbar : HudBar
#@onready var test2D = $Node2D
#
#@export var new_item_activate = false
#@export var new_item_out = false
## Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity_value = ProjectSettings.get_setting("physics/2d/default_gravity")
#
#
##player input
#var movement_input = Vector2.ZERO
#var interact_input = false
#var jump_input = false
#var jump_input_actuation = false
#var climb_input = false 
#var dash_input = false
#var attack_input = false
#@export var facing_direction = false
##player_movement
#const SPEED = 470.0
#const JUMP_VELOCITY = -700.0
#var last_direction = Vector2.RIGHT
#
##mechanics
#var can_dash = true
#var is_jumping = false
#var is_skydiving = false
##states
#var current_state = null
#var prev_state = null
##var dict_item = {
	##0:
	##1:
	##2:
	##3:
	##4:
##}
##nodes
#var herculesscript : HerculesLeafStamp
#
#@onready var STATES = $STATES
#@onready var Raycasts = $Raycasts
#@onready var all_interactions = []
#@onready var item_index = inv_dictionary.invsitems
#@onready var stamp_index = inv_dictionary.invseals
#
#@export var inTimeline = false
#
#@export var dying = false
#func changegravity():
	#PhysicsServer2D.area_set_param(get_viewport().find_world_2d().space, PhysicsServer2D.AREA_PARAM_GRAVITY, 280)
#
#func _ready():
	#
	#Dialogic.timeline_ended.connect(_on_timeline_ended)
	#Dialogic.signal_event.connect(_on_dialogic_signal)
	#for state in STATES.get_children():
		#state.STATES = STATES
		#state.Player = self
	#prev_state = STATES.IDLE
	#current_state = STATES.IDLE
#
#func _physics_process(delta):
	#player_input()
	#change_state(current_state.update(delta))
	#$Label.text = str(current_state.get_name())
	#move_and_slide()
#func gravity(delta):
	#if not is_on_floor() && !is_skydiving:
		#velocity.y += gravity_value * delta
	#if not is_on_floor() && is_skydiving:
		#velocity.y += gravity_value * delta -12
#
#func change_state(input_state):
	#if input_state != null:
		#prev_state = current_state 
		#current_state = input_state
		#
		#prev_state.exit_state()
		#current_state.enter_state()
#func get_next_to_wall():
	#for raycast in Raycasts.get_children():
		#raycast.force_raycast_update() 
		#if raycast.is_colliding():
			#if raycast.target_position.x > 0:
				#return Vector2.RIGHT
			#else:
				#return Vector2.LEFT
	#return null
	#
#
#func player_input():
	#movement_input = Vector2.ZERO
	#if can_move && can_move_si:
		#if Input.is_action_pressed("MoveRight"):
			#if $STATES/SLIDE.is_sliding == 0:
				#movement_input.x += 1
				#$Sprite2D.scale.x = 0.07
				#$sword.position.x = 0
				#$Sprite2D.position.x = 1
				#$PlayerHatCold.scale.x = 0.07
			#facing_direction = false
		#if Input.is_action_pressed("MoveLeft"):
			#if $STATES/SLIDE.is_sliding == 0:
				#movement_input.x -= 1
				#$Sprite2D.scale.x = -0.07
				#$PlayerHatCold.scale.x = -0.07
				#$Sprite2D.position.x = 3.67
				#$sword.position.x = -46
			#facing_direction = true
		#if Input.is_action_pressed("MoveUp"):
			#movement_input.y -= 1
		#if Input.is_action_pressed("MoveDown"):
			#movement_input.y += 1
	#
	## jumps
		#if Input.is_action_pressed("Jump"):
			##if $STATES/SLIDE.is_sliding == 0:
				#jump_input = true
		#else: 
				#jump_input = false
		#if Input.is_action_just_pressed("Jump"):
			##if $STATES/SLIDE.is_sliding == 0:
				#jump_input_actuation = true
		#else: 
				#jump_input_actuation = false
	#
	##climb
		#if Input.is_action_pressed("Climb"):
			#climb_input = true
		#else: 
			#climb_input = false
	#
	##dash
		#if Input.is_action_just_pressed("Dash"):
			#dash_input = true
		#else: 
			#dash_input = false
		#
		#if Input.is_action_just_pressed("Attack"):
			#attack_input = true
		#
		#else: 
			#attack_input = false
#
	#if Input.is_action_just_pressed("Interact"):
			#interact_input = true
	#else: 
			#interact_input = false
		#
#func player():
	#pass
	#
#
#
#
#func _on_dialogic_signal(argument:String):
	#if argument == "deactivate_movement":
		#print("Deactivate Movement!")
		#inTimeline = true
		#can_move = false
	#if argument == "reactivate_movement":
		#print("Reactivate Movement!")
		#can_move = true
	#if argument == "take_item":
		#print("take item")
		#
		#test2D.collect_item(inventoryb)
		#if test2D.item_index[Dialogic.VAR.index].first_item == 0:
			#new_item_activate = true
			#showitem.texture = test2D.item_index[Dialogic.VAR.index].texture
			#$STATES/NEWITEM.color_x = test2D.item_index[Dialogic.VAR.index].color_x
			#$STATES/NEWITEM.color_y = test2D.item_index[Dialogic.VAR.index].color_y
			#$STATES/NEWITEM.color_z = test2D.item_index[Dialogic.VAR.index].color_z
			#test2D.item_index[Dialogic.VAR.index].first_item = 1
	#if argument == "take_stamp":
		#print("take stamp")
		#test2D.collect_stamp(inventory)
#
#
#func _on_interaction_area_area_entered(area: Area2D) -> void:
	#if area.has_method("collect"):
		#if area.itemRes.first_item == 0:
			#new_item_activate = true
			#showitem.texture = area.itemRes.texture
			#$STATES/NEWITEM.color_x = area.itemRes.color_x
			#$STATES/NEWITEM.color_y = area.itemRes.color_y
			#$STATES/NEWITEM.color_z = area.itemRes.color_z
			#area.itemRes.first_item = 1
		#area.collect(inventory)
		#
		#
	#if area.has_method("collectb"):
		#if area.itemRes.first_item == 0:
			#new_item_activate = true
			#showitem.texture = area.itemRes.texture
			#$STATES/NEWITEM.color_x = area.itemRes.color_x
			#$STATES/NEWITEM.color_y = area.itemRes.color_y
			#$STATES/NEWITEM.color_z = area.itemRes.color_z
			#area.itemRes.first_item = 1
		#area.collectb(inventoryb)
		#
	#if area.has_method("collectcoin"):
		#area.collectcoin()
	#
	#if area.has_method("hurt"):
		#manager.lifepoints -= 1
		#if manager.lifepoints == -1:
			#dying = true
	#
	#if area.has_method("heal"):
		#if manager.lifepoints <= manager.lifepoints_max:
			#manager.lifepoints += 1
			#get_out_item.emit()
#
		#
		#
		#
#signal death
#signal get_out_item
#
#func collect_item(inventoryb: Inventoryb):
	#inventoryb.insert(item_index[Dialogic.VAR.index])
	#queue_free()
	#
#func collect_stamp(inventory: Inventory):
	#inventory.insert(stamp_index[Dialogic.VAR.index])
	#queue_free()
	#
#func _on_timeline_ended():
	#Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	#inTimeline = false
	#print("got out")
	## do something else here
#
#
#
#@export var target: Marker2D
#@export var player_target: Marker2D
#
#
	##var valor = Vector2(3,3)
	##
	##camera.get_target_position()
	##camera.set_zoom(valor)
#func coinmultiplier():
	#pass
#
#
#func _on_waterdetection_water_state_changed(is_in_water: bool) -> void:
	#self.is_in_water = is_in_water
	#print("is in wata?")
	#print(is_in_water)
	#
#var is_in_water : bool = false
