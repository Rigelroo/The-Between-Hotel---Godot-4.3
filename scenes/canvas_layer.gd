extends CanvasLayer

class_name Canvas

@onready var stats_ht1 = $Statsbar/HealthThing0000
@onready var stats_ht2 = $Statsbar/HealthThing0001
@onready var healthbar: TextureProgressBar = $Statsbar/Healthbar
@onready var healthface: Sprite2D = $Statsbar/Healthbar/Healthface
@onready var health_player: AnimationPlayer = $Statsbar/AnimationPlayer
@onready var inkbar: TextureProgressBar = $Statsbar/Inkbar
@onready var inkbar_under: Sprite2D = $Statsbar/Inkbar/InkbarUnder
@onready var inkbar_over: Sprite2D = $Statsbar/Inkbar/InkbarOver
@onready var healthlabel: Label = $Statsbar/Label
@onready var node_2d: Node2D = $Statsbar/Node2D
@onready var shake: Sprite2D = $Statsbar/Node2D/Shake
@onready var shake_2: Sprite2D = $Statsbar/Node2D/Shake2
