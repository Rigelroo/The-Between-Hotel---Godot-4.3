#extends "state.gd"
#
#class_name NEWITEM
#
#var can_skip = false
#
#@export var color_x : float
#@export var color_y : float
#@export var color_z : float
#
#
#@export var target : Marker2D
#@export var showeffect: Node2D
#@export var player : CharacterBody2D
#signal out_itemstate
#signal on_itemstate
#
#var normal_zoom_x = null
#var normal_zoom_y = null
#var item_zoom_x = null
#var item_zoom_y = null
#
#func zoom_parameters():
	#var camera = Player.player_camera
	#normal_zoom_x = camera.zoom.x
	#normal_zoom_y = camera.zoom.y
	#item_zoom_x = normal_zoom_x + 0.2
	#item_zoom_y = normal_zoom_y + 0.2
#func update(delta):
	#
	#if Input.is_action_just_pressed("showitem_skip") && can_skip:
		#Player.new_item_activate = false
		#Player.gravity(delta)
#
		#Player.top_level = false
		#out_itemstate.emit()
		#
		#return STATES.IDLE
		#
	#return null
#func enter_state():
	#zoom_parameters()
	#$"../../AnimationPlayer".play("new_item")
	#
	#on_itemstate.emit()
	#get_item()
	#Player.can_move_si = false
	#Player.can_dash = false
	#
	#
#func get_item():
	#var camera = Player.player_camera
	#var show_target = Player.show_target
	#var t = create_tween()
	#t.tween_property(camera, "global_position", show_target.global_position, 0.1)
	#t.tween_property(camera, "zoom", Vector2(item_zoom_x, item_zoom_y), 0.5)
	#Player.showitem.visible = true
	##Player.top_level = true
	#t.tween_property(self, "can_skip", true, 1)
	#
#func _on_newitem_out_itemstate() -> void:
	#var camera = Player.player_camera
	#var target = Player.player_target
	#can_skip = false
#
	#var k = create_tween()
	#Player.can_move_si = true
	##if Player.new_item_activate:
	#print("aaaaaaa")
	#k.tween_property(camera, "zoom", Vector2(normal_zoom_x, normal_zoom_y), 1)
#
	#k.tween_property(camera, "position", target.position, 0.1)
	##k.tween_property(camera, "global_position", target.global_position, 0.1)
	#k.tween_property(Player.showitem, "visible", false, 0.5)
extends "state.gd"

class_name NEWITEM

var can_skip = false

@export var color_x: float
@export var color_y: float
@export var color_z: float

@export var target: Marker2D
@export var showeffect: Node2D
@export var player: CharacterBody2D
signal out_itemstate
signal on_itemstate

var normal_zoom_x = null
var normal_zoom_y = null
var item_zoom_x = null
var item_zoom_y = null

func zoom_parameters():
	var camera = Player.player_camera
	normal_zoom_x = camera.zoom.x
	normal_zoom_y = camera.zoom.y
	item_zoom_x = normal_zoom_x + 0.2
	item_zoom_y = normal_zoom_y + 0.2

func update(delta):
	if Input.is_action_just_pressed("showitem_skip") && can_skip:
		Player.new_item_activate = false
		Player.can_move_si = true  # Permite movimento após sair do estado
		Player.can_dash = true      # Permite dashing após sair do estado
		out_itemstate.emit()
		return STATES.IDLE

	return null

func enter_state():
	zoom_parameters()
	$"../../AnimationPlayer".play("new_item")
	on_itemstate.emit()
	get_item()
	
	# Parar movimento e gravidade do jogador
	Player.velocity = Vector2.ZERO  # Zera a velocidade
	Player.can_move_si = false  # Desabilita movimento
	Player.can_dash = false  # Desabilita dash

func get_item():
	var camera = Player.player_camera
	var show_target = Player.show_target
	var t = create_tween()
	t.tween_property(camera, "global_position", show_target.global_position, 0.1)
	t.tween_property(camera, "zoom", Vector2(item_zoom_x, item_zoom_y), 0.5)
	Player.showitem.visible = true
	t.tween_property(self, "can_skip", true, 1)

func _on_newitem_out_itemstate() -> void:
	var camera = Player.player_camera
	var target = Player.player_target
	can_skip = false
	var k = create_tween()
	Player.can_move_si = true  # Permite movimento ao sair do estado
	Player.can_dash = true      # Permite dashing ao sair do estado
	k.tween_property(camera, "zoom", Vector2(normal_zoom_x, normal_zoom_y), 1)
	k.tween_property(camera, "position", target.position, 0.1)
	k.tween_property(Player.showitem, "visible", false, 0.5)
