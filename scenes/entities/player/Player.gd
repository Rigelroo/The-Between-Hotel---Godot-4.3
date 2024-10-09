@icon("res://Missões/npc icons/persian.png")
extends CharacterBody2D

class_name Player

signal death
signal get_out_item
signal healthChanged
signal temporary
signal inkChanged

@onready var damage_numbers_origin = %DamagenumOrigin

@onready var test2D = $Node2D
@onready var splashdec = $Splashdetection
@onready var hitbox = $Hitbox
@onready var slashbox = $sword
@onready var slashbox_down = $sword1
@onready var stats = get_tree().get_first_node_in_group("Stats")
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var STATES = $STATES
@onready var Raycasts = $Raycasts
@onready var all_interactions = []
@onready var item_index = inv_dictionary.invsitems
@onready var stamp_index = inv_dictionary.invseals

@export_subgroup("Magic System")
@export var magic_abilities: Array[MagicResource]


@export_subgroup("Extra Properties")
@export var is_dealing_damage = false
@export var inTimeline = false
@export var dying = false
@export var SWIN_GRAVITY : float = 0.25
@export var SWIN_VELOCITY_CAP : float = 110
@export var SWIN_JUMP : float = -300
@export var showitem : Sprite2D
@export var ghost_node : PackedScene
@export var new_item_activate = false
@export var new_item_out = false
@export var facing_direction = false

#@onready var ghost_timer = $GhostTimer
#@onready var particles = $GPUParticles2D
@export_subgroup("Movement")
@export var dash_speed = 940
@export var SPEED = 470.0
@export var JUMP_VELOCITY = -700.0
@export var can_interact = false
@export var can_move = true
@export var can_move_si = true

@export_subgroup("Objects and Resources")
@export var manager : MainManager
@export var player_camera : Camera2D
@export var target: Marker2D
@export var player_target: Marker2D
@export var show_target: Marker2D
#@export var camera : Camera2D
@export var inventory : Inventory
@export var inventoryb : Inventoryb
@export var inventoryc : Inventoryc
@export var inv_dictionary : InventoryDictionary


var minInk = null
var maxInk = null
var currentInk = null
var minHealth = null
var maxHealth = null
var currentHealth = null
var currentFurypoints = 0


var damage_value = null
var damage_max = null
var damage_min = null
var crit_chance = null




# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity_value = ProjectSettings.get_setting("physics/2d/default_gravity")


#player input
var movement_input = Vector2.ZERO
var interact_input = false
var jump_input = false
var jump_input_actuation = false
var climb_input = false 
var dash_input = false
var attack_input = false
var breath_input = false

var slashing = false

#player_movement

var last_direction = Vector2.RIGHT

#mechanics
var can_dash = true
var is_jumping = false
var is_skydiving = false
#states
var current_state = null
var prev_state = null
#var dict_item = {
	#0:
	#1:
	#2:
	#3:
	#4:
#}
#nodes
#var herculesscript : HerculesLeafStamp
func set_stats():
	
	minInk = manager.minInk
	maxInk = manager.maxInk
	currentInk = manager.currentInk
	minHealth = manager.minHealth
	maxHealth = manager.maxHealth
	currentHealth = manager.currentHealth
	currentFurypoints = manager.currentFurypoints
	damage_value = manager.damage_value
	damage_max = manager.damage_max
	damage_min = manager.damage_min
	crit_chance = manager.crit_chance

func changegravity():
	PhysicsServer2D.area_set_param(get_viewport().find_world_2d().space, PhysicsServer2D.AREA_PARAM_GRAVITY, 280)

func set_idle():
	current_state = STATES.IDLE


func _ready():
	stats = get_tree().get_first_node_in_group("Stats")
	SignalManager.magic_changed.connect(new_emitter)
	add_to_group("Player")
	
	set_stats()
	$sword/sword_collider.disabled = true
	$sword1/sword_collider2.disabled = true
	
	Global.player_body = self
	Dialogic.timeline_ended.connect(_on_timeline_ended)
	Dialogic.signal_event.connect(_on_dialogic_signal)
	for state in STATES.get_children():
		state.STATES = STATES
		state.Player = self
	prev_state = STATES.IDLE
	current_state = STATES.IDLE
	
func _process(delta: float) -> void:
	if can_emit:
		breathemitting()
		
	playdeath()
	if current_state != STATES.AIRSLASH:
		await $AnimationPlayer.animation_finished
		$sword/sword_collider.disabled = true
		$sword1/sword_collider2.disabled = true
		$sword1/sword_collider3.disabled = true
	elif current_state != STATES.SLASH:
		await $AnimationPlayer.animation_finished
		$sword/sword_collider.disabled = true
		$sword1/sword_collider2.disabled = true
		$sword1/sword_collider3.disabled = true
	if current_state != STATES.HIT:
		%Sprite2D.modulate = "#ffffff"
	#if Input.is_action_just_pressed("Start"):
		#currentHealth += 1
		#healthChanged.emit(currentHealth)
		#emit_signal("temporary")
	

func _physics_process(delta):
	
	player_input()
	change_state(current_state.update(delta))
	$Label.text = str(current_state.get_name())
	move_and_slide()
func gravity(delta):
	if not is_on_floor() && !is_skydiving:
		if(!is_in_water):
			velocity.y += gravity_value * delta
			
		else:
			velocity.y = clampf(velocity.y + (gravity_value * delta * SWIN_GRAVITY), -10000, SWIN_VELOCITY_CAP)
	if not is_on_floor() && is_skydiving:
		if(!is_in_water):
			velocity.y += gravity_value * delta -12
		
func change_state(input_state):
	if input_state != null:
		prev_state = current_state 
		current_state = input_state
		
		prev_state.exit_state()
		current_state.enter_state()
		
func get_next_to_wall():
	for raycast in Raycasts.get_children():
		raycast.force_raycast_update() 
		if raycast.is_colliding():
			if raycast.target_position.x > 0:
				return Vector2.RIGHT
			else:
				return Vector2.LEFT
	return null
	

func player_input():
	movement_input = Vector2.ZERO
	if can_move && can_move_si:
		if Input.is_action_pressed("MoveRight"):
			if $STATES/SLIDE.is_sliding == 0:
				movement_input.x += 1
				#%Breathemitter.scale.x = 0.5
				#%Breathemitter.position.x = 14.2
				$Sprite2D.flip_h = false
				#$Sprite2D.scale.x = 0.07
				$sword.position.x = 0
				%fire_collider.position.x = 50
				
				$Sprite2D.position.x = 1
				$PlayerHatCold.scale.x = 0.07
			facing_direction = false
		if Input.is_action_pressed("MoveLeft"):
			if $STATES/SLIDE.is_sliding == 0:
				movement_input.x -= 1
				#$Sprite2D.scale.x = -0.07
				$Sprite2D.flip_h = true
				#%Breathemitter.scale.x = -0.5
				#%Breathemitter.position.x = -14.2
				%fire_collider.position.x = -60
				$PlayerHatCold.scale.x = -0.07
				$Sprite2D.position.x = 3.67
				$sword.position.x = -46
			facing_direction = true
		if Input.is_action_pressed("MoveUp"):
			movement_input.y -= 1
		if Input.is_action_pressed("MoveDown"):
			movement_input.y += 1
	
	# jumps
	if !is_in_water && can_move && can_move_si:
		#$CollisionShape2D.position.y = 0
		$CollisionShape2D.disabled = false
		$CollisionShape2D2.disabled = true
		$AnimationPlayer2.active = false
		$AnimationPlayer.active = true
	if is_in_water  && can_move && can_move_si:
		#$CollisionShape2D.position.y = -9.6
		$CollisionShape2D.disabled = true
		$CollisionShape2D2.disabled = false
		$AnimationPlayer2.active = true
		$AnimationPlayer.active = false
	if !is_in_water && can_move && can_move_si:
		if Input.is_action_pressed("Jump"):
			
			#if $STATES/SLIDE.is_sliding == 0:
				jump_input = true
		else: 
				jump_input = false
	if !is_in_water && can_move && can_move_si:
		if Input.is_action_just_pressed("Jump"):
			#if $STATES/SLIDE.is_sliding == 0:
				jump_input_actuation = true
		else: 
				jump_input_actuation = false
	if is_in_water && can_move && can_move_si:
		if Input.is_action_just_pressed("Jump"):
			velocity.y += SWIN_JUMP
	if !is_in_water && can_move && can_move_si:
	#climb
		if manager.ffemblem_equiped or manager.frozenheart_equiped:
			if Input.is_action_pressed("Magic"):
				breath_input = true
			else:
				breath_input = false
		if Input.is_action_pressed("Climb"):
			climb_input = true
		else: 
			climb_input = false
	#dash
		if Input.is_action_just_pressed("Dash"):
			dash_input = true
		else: 
			dash_input = false
		if Input.is_action_just_pressed("Attack"):
			attack_input = true
		else: 
			attack_input = false
			
		#if Input.is_action_pressed("Attack"):
			#is_charging = true
			#charge_time = 0  # Reset charge time
		#if Input.is_action_just_released("Attack"):
			#if is_charging:
				#perform_charge_attack()
				#is_charging = false
			#else:
				#attack_input = true
		
		#else: 
			#attack_input = false
	
		if Input.is_action_just_pressed("Interact"):
			interact_input = true
		else: 
			interact_input = false
		

var charge_time = 0
var is_charging = false
var max_charge = 2.0  # Maximum charge time in seconds
var charge_power = 1.0  # Basic attack power

func perform_charge_attack():
	$AnimationPlayer.play("chslash_frost")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("idle")

func charge_attack(delta):
	charge_time += delta
	charge_time = min(charge_time, max_charge)


func player():
	pass




func _on_dialogic_signal(argument:String):
	if argument == "deactivate_movement":
		print("Deactivate Movement!")
		inTimeline = true
		can_move = false
	if argument == "reactivate_movement":
		print("Reactivate Movement!")
		can_move = true
	if argument == "take_item":
		print("take item")
		
		test2D.collect_item(inventoryb)
		if test2D.item_index[Dialogic.VAR.index].first_item == 0:
			new_item_activate = true
			showitem.texture = test2D.item_index[Dialogic.VAR.index].texture
			$STATES/NEWITEM.color_x = test2D.item_index[Dialogic.VAR.index].color_x
			$STATES/NEWITEM.color_y = test2D.item_index[Dialogic.VAR.index].color_y
			$STATES/NEWITEM.color_z = test2D.item_index[Dialogic.VAR.index].color_z
			test2D.item_index[Dialogic.VAR.index].first_item = 1
	if argument == "take_stamp":
		print("take stamp")
		if test2D.stamp_index[Dialogic.VAR.index].first_item == 0:
			new_item_activate = true
			showitem.texture = test2D.stamp_index[Dialogic.VAR.index].texture
			$STATES/NEWITEM.color_x = test2D.stamp_index[Dialogic.VAR.index].color_x
			$STATES/NEWITEM.color_y = test2D.stamp_index[Dialogic.VAR.index].color_y
			$STATES/NEWITEM.color_z = test2D.stamp_index[Dialogic.VAR.index].color_z
			test2D.stamp_index[Dialogic.VAR.index].first_item = 1
		test2D.collect_stamp(inventory)


func _on_interaction_area_area_entered(area: Area2D) -> void:
	if area.has_method("collect"):
		if area.itemRes.first_item == 0:
			new_item_activate = true
			showitem.texture = area.itemRes.texture
			showitem.animation_player.play("surge")
			$STATES/NEWITEM.color_x = area.itemRes.color_x
			$STATES/NEWITEM.color_y = area.itemRes.color_y
			$STATES/NEWITEM.color_z = area.itemRes.color_z
			area.itemRes.first_item = 1
		area.collect(inventory)
		
		
	if area.has_method("collectb"):
		if area.itemRes.first_item == 0:
			new_item_activate = true
			showitem.animation_player.play("surge")
			showitem.texture = area.itemRes.texture
			$STATES/NEWITEM.color_x = area.itemRes.color_x
			$STATES/NEWITEM.color_y = area.itemRes.color_y
			$STATES/NEWITEM.color_z = area.itemRes.color_z
			area.itemRes.first_item = 1
		area.collectb(inventoryb)
	
	if area.has_method("collectcontainer"):
		if area.itemRes.first_item == 0:
			new_item_activate = true
			showitem.animation_player.play("surge")
			showitem.texture = area.itemRes.texture
			$STATES/NEWITEM.color_x = area.itemRes.color_x
			$STATES/NEWITEM.color_y = area.itemRes.color_y
			$STATES/NEWITEM.color_z = area.itemRes.color_z
			area.itemRes.first_item = 1
		area.collectcontainer()

	if area.has_method("collectcoin"):
		area.collectcoin()
	
	if area.has_method("hurt"):
		manager.lifepoints -= 1
		if manager.lifepoints == -1:
			dying = true
	
	if area.has_method("heal"):
		if manager.lifepoints <= manager.lifepoints_max:
			manager.lifepoints += 1
			get_out_item.emit()

		
		
		


func collect_item(inventoryb: Inventoryb):
	inventoryb.insert(item_index[Dialogic.VAR.index])
	queue_free()
	
func collect_stamp(inventory: Inventory):
	inventory.insert(stamp_index[Dialogic.VAR.index])
	queue_free()
	
func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	inTimeline = false
	print("got out")
	# do something else here




	#var valor = Vector2(3,3)
	#
	#camera.get_target_position()
	#camera.set_zoom(valor)
func coinmultiplier():
	pass


func _on_waterdetection_water_state_changed(is_in_water: bool) -> void:
	self.is_in_water = is_in_water
	print("is in wata?")
	print(is_in_water)
	
var is_in_water : bool = false




func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("EnemyAttackboxs"):
		#area.get_parent().deal_damage()
		var dvalue = area.owner.damage_value
		deal_damage(dvalue, area)
		
		is_dealing_damage = true
		$AnimationPlayer.play("Damage")
		stats.updatehealth()

	
func playdeath():
	if currentHealth <= minHealth:
		dying = true

func knockback(delta: float) -> void:
	
	velocity.x += SPEED * delta 

func deal_damage(value: int, area: Area2D):
	#var criticalchance = randi_range(1, 10)
	var damage_total = value
	var is_critical = area.owner.crit_chance > randf()
	
	if is_critical:
		damage_total = value * 2
		
	currentHealth -= damage_total
	Damagenumbers.display_number(damage_total, damage_numbers_origin.global_position, is_critical)

func deal_projectiledamage(value: int, area: Area2D):
	#var criticalchance = randi_range(1, 10)
	var damage_total = value
	var is_critical = area.crit_chance > randf()
	if is_critical:
		damage_total = value * 2
		
	currentHealth -= damage_total
	Damagenumbers.display_number(damage_total, damage_numbers_origin.global_position, is_critical)
	stats.updatehealth()
	is_dealing_damage = true
	$AnimationPlayer.play("Damage")
	area.collide()

var can_emit = false

var breathemitter = null
var emitterscene = null

var magic_index = SignalManager.breath_index
func new_emitter():
	magic_index = SignalManager.breath_index
	var emitter = magic_abilities[magic_index].particles_scene_str
	var emitterinst = load(emitter)
	var breathemitter = emitterinst.instantiate()
	
	emitterscene = get_tree().get_first_node_in_group("Breathemitters")
	emitterscene.bye()
	
	
	
	self.add_child(breathemitter)
	emitterscene = get_tree().get_first_node_in_group("Breathemitters")
	
	breathemitter.position.x = 14.2
	breathemitter.position.y = -0.4
	
	
	


func breathemitting():
	pass
	#if Input.is_action_pressed("MoveLeft"):
		#get_node("%Breathemitter").position.x = -14.2
		#%fire_collider.position.x = -60
	#if Input.is_action_pressed("MoveRight"):
		#get_node("%Breathemitter").scale.x = 0.5
		#%fire_collider.position.x = 14.2
	#
	#if get_node("%Breathemitter").emitting:
		#%fire_collider.disabled = false
#
	#if !get_node("%Breathemitter").emitting:
		#%fire_collider.disabled = true
