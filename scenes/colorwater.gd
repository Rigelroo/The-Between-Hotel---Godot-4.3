extends Area2D
@export var color : Color
@export var colorx : float
@export var colory : float
@export var colorz : float
@export var world : World
@export var marker : Marker2D

func _on_body_entered(body: CharacterBody2D) -> void:
	print("color")
	world.color_x = colorx
	world.color_y = colory
	world.color_z = colorz
	world.splashposition = self.position.y


func _on_area_entered(area: Area2D) -> void:
	print("color")
