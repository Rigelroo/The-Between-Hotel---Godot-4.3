extends Control

class_name StatsBar


@onready var stats_ht1 = $HealthThing0000
@onready var stats_ht2 = $HealthThing0001
@onready var healthbar: TextureProgressBar = $Healthbar
@onready var healthface: Sprite2D = $Healthbar/Healthface
@onready var health_player: AnimationPlayer = $AnimationPlayer
@onready var inkbar: TextureProgressBar = $Inkbar
@onready var inkbar_under: Sprite2D = $Inkbar/InkbarUnder
@onready var inkbar_over: Sprite2D = $Inkbar/InkbarOver
@onready var healthlabel: Label = $Label
@onready var node_2d: Node2D = $Node2D
@onready var shake: Sprite2D = $Node2D/Shake
@onready var shake_2: Sprite2D = $Node2D/Shake2


@onready var player = null


func _ready() -> void:
	player = SignalManager.player
	SignalManager.world_loaded.connect(world_ready)
	SignalManager.connect("stats_updated", update_all)
	

func world_ready() -> void:
	player = SignalManager.player
	player.healthChanged.connect(update_health)
	player.inkChanged.connect(update_ink)
	#updatehealth()
	
	#updateink()

func update_all(stats_type, new_value):
	if stats_type == "inkpoints":
		update_ink(new_value)
	elif stats_type == "healthpoints":
		update_health(new_value) 


func update_health(new_value):
	healthbar.value = player.currentHealth * 100 / player.maxHealth
	healthlabel.text = str(player.currentHealth)

	if player.currentHealth > 10:
		shake.visible = false
		shake_2.visible = false


	if player.currentHealth <= 10:
		health_player.play("Danger")
		shake.visible = true
		shake_2.visible = true
		
	if player.currentHealth <= 0:
		health_player.play("0")
	if player.currentHealth >= 80 && player.currentHealth <= 100:
		health_player.play("80_100")
	if player.currentHealth >= 60 && player.currentHealth < 80:
		health_player.play("60_79")
	if player.currentHealth >= 35 && player.currentHealth < 60:
		health_player.play("35_59")
	if player.currentHealth > 10 && player.currentHealth < 35:
		health_player.play("20_34")
func update_ink(new_value):
	inkbar.value = player.currentInk * 100 / player.maxInk
	
