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


@onready var berserkcontainer: BerserkBar = %HBoxContainer


@onready var player = null
var new_value
var stats_type
func _ready() -> void:
	player = SignalManager.player
	SignalManager.world_loaded.connect(world_ready)
	#SignalManager.connect("stats_updated", update_all, new_value )
	#SignalManager.stats_updated.connect(update_all.bind(SignalManager.stats_type, SignalManager.new_value))
	#SignalManager.connect("stats_updated", Callable(self, "method_name").bind([extra, arguments]))
	SignalManager.stats_updated.connect(update_all)


func world_ready() -> void:
	player = SignalManager.player
	player.healthChanged.connect(update_health)
	player.inkChanged.connect(update_ink)
	update_health(player.components.stats_component.currentHealth)
	update_ink(player.components.stats_component.currentInk)
	update_berserk(player.components.stats_component.currentFurypoints)
	#updatehealth()
	
	#updateink()

func update_all(stats):
	var stats_type = stats[0]
	var new_value = stats[1]
	if stats_type == "inkpoints":
		update_ink(new_value)
	elif stats_type == "berserkpoints":
		update_berserk(new_value)
	elif stats_type == "healthpoints":
		update_health(new_value) 


func update_berserk(new_value):
	berserkcontainer.update_stats(new_value)

func update_health(new_value):
	healthbar.value = new_value * 100 / player.components.stats_component.maxHealth
	healthlabel.text = str(new_value)

	if new_value > 10:
		shake.visible = false
		shake_2.visible = false


	if new_value <= 10:
		health_player.play("Danger")
		shake.visible = true
		shake_2.visible = true
		
	if new_value <= 0:
		health_player.play("0")
	if new_value >= 80 && player.components.stats_component.currentHealth <= 100:
		health_player.play("80_100")
	if new_value >= 60 && new_value < 80:
		health_player.play("60_79")
	if new_value >= 35 && new_value < 60:
		health_player.play("35_59")
	if new_value > 10 && new_value < 35:
		health_player.play("20_34")


func update_ink(new_value):
	inkbar.value = new_value * 100 / player.components.stats_component.maxInk
