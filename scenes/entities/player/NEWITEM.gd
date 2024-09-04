extends "state.gd"

class_name NEWITEM

var can_skip = false

@export var color_x : float
@export var color_y : float
@export var color_z : float


@export var target : Marker2D
@export var showeffect: Node2D
@export var player : CharacterBody2D
signal out_itemstate
signal on_itemstate

func update(delta):
	Player.gravity(delta)
	
	if Input.is_action_just_pressed("showitem_skip") && can_skip:
		Player.new_item_activate = false
		
		Player.top_level = false
		out_itemstate.emit()
		
		return STATES.IDLE
		
	return null
func enter_state():
	$"../../AnimationPlayer".play("new_item")
	Player.velocity.x = 0
	on_itemstate.emit()
	get_item()
	Player.can_move_si = false
	Player.can_dash = false
	
	
func get_item():
	var camera = Player.player_camera
	var show_target = Player.show_target
	var t = create_tween()
	t.tween_property(camera, "position", show_target.position, 0.1)
	t.tween_property(camera, "zoom", Vector2(1.5, 1.5), 0.5)
	Player.showitem.visible = true
	Player.top_level = true
	t.tween_property(self, "can_skip", true, 1)
	
func _on_newitem_out_itemstate() -> void:
	var camera = Player.player_camera
	var target = Player.player_target
	can_skip = false
	var k = create_tween()
	Player.can_move_si = true
	#if Player.new_item_activate:
	print("aaaaaaa")
	k.tween_property(camera, "zoom", Vector2(0.7, 0.7), 1)
	#k.tween_property(camera, "position", target.position, 0.1)
	k.tween_property(camera, "position", target.position, 0.1)
	k.tween_property(Player.showitem, "visible", false, 0.5)
