extends Node

class_name PhycisProps

var gravity_scale = 10.0 # the setter bellow is for this property
var physics_objects = [Player] # add your physics objects here
@onready var Player = $".."
func set_gravity_scale(new_scale) -> void:
  self.gravity_scale = new_scale
  for obj in physics_objects:
	obj.gravity_scale = self.gravity_scale
