extends Node2D
@export var coloreffect : Sprite2D
@export var player : CharacterBody2D
@export var tcham1 : Sprite2D
@export var tcham2 : Sprite2D
@export var animation : AnimationPlayer
@export var animationtext : AnimationPlayer
@export var newitem : Node
@export var playertarget : Marker2D
var pressed = false

signal animatxt

func _ready() -> void:
	newitem.on_itemstate.connect(new_item_activate)
	newitem.out_itemstate.connect(new_item_out)
	self.visible = false
func _process(_delta: float) -> void:
	var num = 0.01
	if self.scale.x < num:
		self.visible = false
	else:
		self.visible = true
	
	
	
func colormodulate():
	var color = Color(newitem.color_x, newitem.color_y, newitem.color_z)
	coloreffect.modulate = color

		#if pressed:
			#t.tween_property(self, "visible", false, 1)
	#t.tween_property(self, "position", player.position, 0.1)
	
func twink():
		var k = create_tween()
		k.tween_property(self, "scale", Vector2(0.07, 0.07), 0.5)
		animation.active = true


func _on_animatxt() -> void:
	print("@")
	animationtext.play("new_animation")
	await animationtext.animation_finished
	animationtext.pause()

func new_item_out():
	var t = create_tween()
	if !player.new_item_activate:
		
		t.tween_property(self, "scale", Vector2(0.001, 0.001), 1)
		animation.active = false
		

func new_item_activate():
	animatxt.emit()
	colormodulate()
	if player.new_item_activate:
		animation.play("tcham1")
		self.visible = true
		twink()
