extends Control

@onready var texture_progress_bar: TextureProgressBar = $CenterContainer/TextureProgressBar

func _ready() -> void:
	SignalManager.world_loaded.connect(world_ready)


func world_ready() -> void:
	
	var player = SignalManager.player
	player.components.stats_component.healthChanged.connect(updatePoints)

func updatePoints(new_value: float):
	var tween = create_tween()
	
	tween.tween_property(texture_progress_bar, "value", new_value, 0.8)
