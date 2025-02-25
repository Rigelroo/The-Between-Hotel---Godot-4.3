@icon("res://Missões/npc icons/persian.png")
extends CharacterBody2D

class_name Playercharacter

func movable_entitie():
	pass

signal death
signal get_out_item

signal temporary
signal inkChanged

@onready var inout_label: Label = $INOUTLabel


enum FloorHazards {  
	Spikes,      
	Instdeath,  
	Poison  
}  

@onready var test2D = $Node2D
@onready var splashdec = $Splashdetection
@onready var hitbox = $Hitbox
@onready var slashbox = $sword
@onready var slashbox_down = $sword1
@onready var stats = get_tree().get_first_node_in_group("Stats")
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = %Sprite2D

@onready var stats_component: StatsComponent = %StatsComponent
@onready var stamps_component: StampComponent = %StampsComponent
@onready var terrain_component: TerrainComponent = %TerrainComponent
@onready var damage_component: DamageComponent = %DamageComponent



@onready var STATES = $STATES
@onready var Raycasts = $Raycasts
@onready var all_interactions = []
@onready var item_index = null#inv_dictionary.invsitems
@onready var stamp_index = null#inv_dictionary.invseals

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
@export var dash_speed = 1880 
@export var SPEED = 470.0 * 1.5
@export_range(0, 3, 0.05) var RUN_SPEED_MULTIPLIER : float = 1.8:
	set(nv):
		RUN_SPEED_MULTIPLIER = nv
		SPRINT_SPEED = SPEED * RUN_SPEED_MULTIPLIER


@export var JUMP_VELOCITY = -700.0 * 1.5
@export var variable_jump_value = -300
@export var max_fall_speed = -900.0 * 1.5

@export var COYOTE_TIME = 140
@export var AIR_HANG_MULTIPLIER = 0.95
@export var AIR_HANG_THRESHOLD = 50
@export var Y_SMOOTHING = 0.8
@export var AIR_X_SMOOTHING = 0.10
@export var JUMP_BUFFER_TIME = 100
var lastJump_msec : int
var lastFloorMsec = 0
@export_range(1, 2000, 0.1) var slide_deceleration : int = 500
@export var can_interact = false
@export var can_move = true
@export var can_move_si = true
var SPRINT_SPEED : float = SPEED

@export_subgroup("Objects and Resources")
@export var player_camera : Camera2D
@export var target: Marker2D
@export var player_target: Marker2D
@export var show_target: Marker2D
#@export var camera : Camera2D
@export var manager : MainManager
@export var inventory : Inventory
@export var inventoryb : Inventoryb
@export var inventoryc : Inventoryc
@export var inv_dictionary : InventoryDictionary

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity_value = ProjectSettings.get_setting("physics/2d/default_gravity")

var prevVelocity = Vector2.ZERO

#player input
var movement_input = Vector2.ZERO

var interact_input = false
var jump_input = false
var jump_input_actuation = false
var sprint_input = false
var climb_input = false 
var dash_input = false
var attack_input = false
var breath_input = false
var balir_input = false
var slashing = false
var gliding_actuation = false
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
var pos = Vector2.ZERO
var inventoryequiped_array = []

@onready var components: Node2D = $Components

var saved_position = []

func save():
	var position_array 
	
	var saved_scene = get_parent().scene_file_path
	var saved_scenename = get_parent().nome_cena
	SaveSys.saved_current_scene = saved_scene
	SaveSys.saved_current_scenename = saved_scenename
	if saved_position:
		if !saved_position.is_empty():
			position_array = [saved_position[0],saved_position[1]]
		else:
			position_array = [position.x, position.y]
	else:
		position_array = [position.x, position.y]
	var object_data = {
		"position": position_array,  # Salva a posição
	}
	
	# Salva no dicionário global de saves em SaveSys
	SaveSys.save_scene_state(get_parent().scene_name, name, object_data)
	return object_data

func load_player_state():
	var pos_data
	var npc_data = SaveSys.load_scene_state(get_parent().scene_name, "Player")
	if npc_data != null:
		if npc_data.has("position"): 
			pos_data = npc_data["position"]
			if pos_data.size() == 2:
				position = Vector2(pos_data[0], pos_data[1])



func changegravity():
	PhysicsServer2D.area_set_param(get_viewport().find_world_2d().space, PhysicsServer2D.AREA_PARAM_GRAVITY, 280)

func set_idle():
	current_state = STATES.IDLE

 
func _ready():
	SignalManager.its_saving.connect(save)
	stats = get_tree().get_first_node_in_group("Stats")
	SignalManager.magic_changed.connect(new_emitter)
	add_to_group("Player")
	

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

@onready var jumpcloud = preload("res://jump_cloud.tscn")

func jump_particles():
	if is_on_floor():
		var new_node = jumpcloud.instantiate()
		get_parent().add_child(new_node)
		new_node.global_position = $JumpTarget.global_position

func _physics_process(delta):
	
	if is_on_floor():
		lastFloorMsec = Time.get_ticks_msec()
	player_input()
	change_state(current_state.update(delta))
	if %AnimationPlayer.current_animation != "jump_slide":
		%Sprite2D.rotation = 0
	if current_state != STATES.HLEAF:
		is_skydiving = false

	if prev_state == STATES.HLEAF:
		if current_state != STATES.HLEAF:
			is_skydiving = false
	if current_state != STATES.SLIDE:
		%Sprite2D.position.x = 0


	if prev_state == STATES.SLASH or prev_state == STATES.AIRSLASH:
		if current_state != STATES.AIRSLASH:
			#await $AnimationPlayer.animation_finished
			$sword/sword_collider.disabled = true
			$sword1/sword_collider2.disabled = true
			$sword1/sword_collider3.disabled = true
		elif current_state != STATES.SLASH:
			#await $AnimationPlayer.animation_finished
			$sword/sword_collider.disabled = true
			$sword1/sword_collider2.disabled = true
			$sword1/sword_collider3.disabled = true
	if current_state != STATES.HIT:
		%Sprite2D.modulate = "#ffffff"
	#if Input.is_action_just_pressed("Start"):
		#currentHealth += 1
		#healthChanged.emit(currentHealth)
		#emit_signal("temporary")

	$Label.text = str(current_state.get_name())
	$SPEEDLabel.text = "SPEED: " + str(SPEED)

	prevVelocity = velocity
	move_and_slide()

func gravity(delta) -> float:
	var gravity_value = ProjectSettings.get_setting("physics/2d/default_gravity")
	var regravity = 0.0

	if is_on_floor():
		velocity.y = 0
		return 0.0 
	if current_state.name == "SLIDE":
		regravity = (gravity_value) * delta
	if current_state.name == "FALL":
		regravity = (3.5 * gravity_value) * delta
	elif current_state.name == "HLEAF":
		if !is_on_floor():
			regravity = (gravity_value + 100 / 2.5) * delta
	else:
		if is_in_water:
			regravity = clamp(velocity.y + (gravity_value * delta * SWIN_GRAVITY), -10000, SWIN_VELOCITY_CAP) - velocity.y
		else:
			regravity = gravity_value * delta

	return regravity



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

var jumpBuffertime = 1.45

func handleJumpBuffer():
	if Input.is_action_just_pressed("Jump"):
		$STATES/JUMP/BufferTimer.start(jumpBuffertime)


func player_input():
	movement_input = Vector2.ZERO
	if can_move and can_move_si:
		if current_state == $STATES/SLIDE:
				if Input.is_action_pressed("MoveRight"):
					$Emitters/FrictionParticles.scale.x = 1
					$Emitters/FrictionParticles.position.x = 114.0
				if Input.is_action_pressed("MoveLeft"):
					$Emitters/FrictionParticles.scale.x = -1
					$Emitters/FrictionParticles.position.x = -114.0

	if can_move and can_move_si:
		if not $STATES/SLIDE.is_sliding:
				if Input.is_action_pressed("MoveRight"):
					%Trayemmiter.scale.x = -1
					$Emitters/FrictionParticles.scale.x = 1
					$Emitters/FrictionParticles.position.x = -114.0
					movement_input.x += 1
					if !$STATES/JUMP.wall_jump:
						$Sprite2D.flip_h = false
					#else:
						#$Sprite2D.flip_h = true
					$sword.position.x = 0
					%fire_collider.position.x = 50
					$Sprite2D.position.x = 1
					$PlayerHatCold.scale.x = 0.07
					facing_direction = false
				if Input.is_action_pressed("MoveLeft"):
					$Emitters/FrictionParticles.scale.x = -1
					$Emitters/FrictionParticles.position.x = 114.0
					%Trayemmiter.scale.x = 1
					movement_input.x -= 1
					if !$STATES/JUMP.wall_jump:
						$Sprite2D.flip_h = true
					#else:
						#$Sprite2D.flip_h = false
					%fire_collider.position.x = -60
					$PlayerHatCold.scale.x = -0.07
					$Sprite2D.position.x = 3.67
					$sword.position.x = -46
					facing_direction = true
			
			
		if Input.is_action_pressed("MoveUp"):
			movement_input.y -= 1
		if Input.is_action_pressed("MoveDown"):
			movement_input.y += 1
	
		if Input.is_action_pressed("Jump") and !is_on_floor() and manager.hleaf_equiped:
			gliding_actuation = true
		else:
			gliding_actuation = false
			
	
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
		if Input.is_action_pressed("MoveRight"):
			%Trayemmiter.scale.x = -1
			if $STATES/SLIDE.is_sliding == 0:
				movement_input.x += 1
				$Sprite2D.flip_h = false

		if Input.is_action_pressed("MoveLeft"):
			%Trayemmiter.scale.x = 1
			if $STATES/SLIDE.is_sliding == 0:
				movement_input.x -= 1
				$Sprite2D.flip_h = true

		if Input.is_action_pressed("MoveUp"):
			movement_input.y -= 1
		if Input.is_action_pressed("MoveDown"):
			movement_input.y += 1
#or $STATES/JUMP/BufferTimer.time_left > 0 
	# Jump handling
	if not $STATES/SLIDE.is_sliding:
		if !is_skydiving && !is_in_water && can_move && can_move_si:
			var jumptime = Time.get_ticks_msec() - lastJump_msec
			if Input.is_action_just_pressed("Jump"):
				$STATES/JUMP/Jumptimer.start()
				$STATES/JUMP/BufferTimer.stop()
				print($STATES/JUMP/BufferTimer.time_left)
				jump_input_actuation = true
			else:
				jump_input_actuation = false

	if is_in_water && can_move && can_move_si:
		if Input.is_action_just_pressed("Jump"):
			velocity.y += SWIN_JUMP


	if !is_in_water && can_move && can_move_si:
	#climb

		if Input.is_action_just_pressed("Magic"):
			print(inventoryc.stampslots[0].item.use())
				#breath_input = true
			#else:
				#breath_input = false
		if Input.is_action_pressed("Climb"):
			climb_input = true
		else: 
			climb_input = false
	#dash
		if Input.is_action_just_pressed("Dash"):
			dash_input = true
		else: 
			dash_input = false
		
		if Input.is_action_pressed("Run"):
			sprint_input = true
			
		else: 
			sprint_input = false
			
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
		
		if Input.is_action_just_pressed("Balir"):
			balir_input = true
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
			$STATES/NEWITEM.color = test2D.item_index[Dialogic.VAR.index].color
			#$STATES/NEWITEM.color_x = test2D.item_index[Dialogic.VAR.index].color_x
			#$STATES/NEWITEM.color_y = test2D.item_index[Dialogic.VAR.index].color_y
			#$STATES/NEWITEM.color_z = test2D.item_index[Dialogic.VAR.index].color_z
			test2D.item_index[Dialogic.VAR.index].first_item = 1
	if argument == "take_stamp":
		print("take stamp")
		if test2D.stamp_index[Dialogic.VAR.index].first_item == 0:
			new_item_activate = true
			showitem.texture = test2D.stamp_index[Dialogic.VAR.index].texture
			$STATES/NEWITEM.color = test2D.stamp_index[Dialogic.VAR.index].color
			#$STATES/NEWITEM.color_x = test2D.stamp_index[Dialogic.VAR.index].color_x
			#$STATES/NEWITEM.color_y = test2D.stamp_index[Dialogic.VAR.index].color_y
			#$STATES/NEWITEM.color_z = test2D.stamp_index[Dialogic.VAR.index].color_z
			test2D.stamp_index[Dialogic.VAR.index].first_item = 1
		test2D.collect_stamp(inventory)


func _on_interaction_area_area_entered(area: Area2D) -> void:
	if area.has_method("collect"):
		if area.itemRes.first_item == 0:
			new_item_activate = true
			showitem.texture = area.itemRes.texture
			showitem.animation_player.play("surge")
			$STATES/NEWITEM.color = area.itemRes.color
			#$STATES/NEWITEM.color_x = area.itemRes.color_x
			#$STATES/NEWITEM.color_y = area.itemRes.color_y
			#$STATES/NEWITEM.color_z = area.itemRes.color_z
			area.itemRes.first_item = 1
		area.collect(inventory)
		
		
	if area.has_method("collectb"):
		if area.itemRes.first_item == 0:
			new_item_activate = true
			showitem.animation_player.play("surge")
			showitem.texture = area.itemRes.texture
			$STATES/NEWITEM.color = area.itemRes.color
			#$STATES/NEWITEM.color_x = area.itemRes.color_x
			#$STATES/NEWITEM.color_y = area.itemRes.color_y
			#$STATES/NEWITEM.color_z = area.itemRes.color_z
			area.itemRes.first_item = 1
		area.collectb(inventoryb)
	
	if area.has_method("collectcontainer"):
		if area.itemRes.first_item == 0:
			new_item_activate = true
			showitem.animation_player.play("surge")
			showitem.texture = area.itemRes.texture
			$STATES/NEWITEM.color = area.itemRes.color
			#$STATES/NEWITEM.color_x = area.itemRes.color_x
			#$STATES/NEWITEM.color_y = area.itemRes.color_y
			#$STATES/NEWITEM.color_z = area.itemRes.color_z
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
		var dvalue = area.get_parent().damage_value
		damage_component.deal_damage(dvalue, area)
		
		is_dealing_damage = true
		$AnimationPlayer.play("Damage")

	if area.is_in_group("badProjectile"):
		var dvalue = area.owner.damage_value
		damage_component.deal_damage(dvalue, area)
		
		is_dealing_damage = true
		$AnimationPlayer.play("Damage")
		




func knockback(delta: float) -> void:
	
	velocity.x += SPEED * delta 

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



func move_towards_target(delta: float, target, whocalled):
	var target_position = target.global_position
	var direction = (target_position - position).normalized()
	velocity = (SPEED * 0.4) * direction
	move_and_slide()
	if direction.x != 0:
		movement_input.x += 1
		$AnimationPlayer.play("run")


	if global_position.distance_to(target_position) < 50:
		velocity = Vector2.ZERO
		$AnimationPlayer.play("idle")
		whocalled.player_can_move = false
		whocalled.play_hug(self)



func _on_jumptimer_timeout() -> void:
	if !Input.is_action_pressed("Jump"):
		if velocity.y < variable_jump_value:
			velocity.y = variable_jump_value 
	else:
		pass
		#print("highjump")


func _on_hitbox_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body is TileMapLayer:
		%TerrainComponent._process_tiledata(body, body_rid)
		
