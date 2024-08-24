
extends Node2D
@onready var areaInteraction = $Area2D/AreaInteraction
@onready var player = $"."
@onready var global = $Global
#@export var can_interact = false
var player_in_area = false
var is_chatting = false
var Player = null

func _ready():
	#$AnimatedSprite2D3.play("inactive")
	pass
