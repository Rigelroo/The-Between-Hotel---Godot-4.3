class_name HealthBar
extends Control
@onready var label: Label = $Label

@onready var h_box_container := $HBoxContainer

@export var destroy_containers := false:
	set(v):
		var a = h_box_container.get_children()
		for i in h_box_container.get_child_count():
			a[i].queue_free()

@export var containers = 1
@export var hpoints = 2:
	set(nv):
		hpoints = nv
		if h_box_container:
			pass
			#fill_containers()




const HEALTHCONTAINER = preload("res://Objects/healthcontainer.tscn")

func updateHearts(currentHealth: int):
	var hearts = $HBoxContainer.get_children()
	var pieces = currentHealth
	for i in hearts.size():
		var child = hearts[i]
		if pieces >= 2:
			
			child.points = 2
			pieces -= 2
			
		elif pieces == 1:
			child.points = 1
			pieces -= 1
		else:
			child.points = 0
		print(pieces)
	#for i in range(currentHealth, hearts.size()):
		#hearts[i].update_points(0)


func _on_resource_changed():
	print("My resource just changed!")

func create_maxhealth_points(max_hpoints: int):
		var t = create_tween()
		for i in max_hpoints:
			if h_box_container.get_child_count() == max_hpoints:
				break
			elif h_box_container.get_child_count() > max_hpoints:
				var a = h_box_container.get_children()
				for j in h_box_container.get_child_count() - max_hpoints:
					containers = h_box_container.get_child_count() - max_hpoints
					var tween = get_tree().create_tween()
					tween.tween_property(a[j], "scale", Vector2(0,0), 0.5) #.set_trans(Tween.TRANS_BOUNCE)
					tween.tween_callback(a[j].queue_free)
				break

			var containers = h_box_container.get_child(i)
			var new_container = HEALTHCONTAINER.instantiate()
			h_box_container.add_child(new_container)
			var tween = get_tree().create_tween()
			tween.tween_property(new_container.get_child(0), "scale", Vector2(0.6,0.6), 1) #.set_trans(Tween.TRANS_BOUNCE)
		await get_tree().create_timer(0.8).timeout
		updateHearts(SignalManager.player.components.stats_component.currentHealth)

func create_containers(max: int):
	for i in range(max):
		var new_container = HEALTHCONTAINER.instantiate()
		h_box_container.add_child(new_container)
	print("hp",SignalManager.player.components.stats_component.currentHealth)
	updateHearts(SignalManager.player.components.stats_component.currentHealth)

var containerssprite = {
	"hp_full" : "res://Sprites/Hud/hp_full_sprite.png",
	"hp_empty" : "res://Sprites/Hud/hp_full_empty.png",
	"hp_half" : "res://Sprites/Hud/hp_full_half.png",
}



func fill_containers():
	var depoint = hpoints
	#label.text = hpoints
	for h in h_box_container.get_children():
		depoint -= 1
		if depoint >= 2:
			
			var tween = get_tree().create_tween()
			label.text = str(depoint)
			h.sprite_2d.frame = 2
		elif depoint < 2 and depoint > 0:
			h.sprite_2d.frame = 1
		elif depoint <= 0:
			h.sprite_2d.frame = 0
			
		


 
func _ready() -> void:
	SignalManager.world_loaded.connect(world_ready)
	

func world_ready() -> void:
	
	var player = SignalManager.player
	player.components.stats_component.healthChanged.connect(updateHearts)
	player.components.stats_component.Changecontainers.connect(create_maxhealth_points)
	create_containers(player.components.stats_component.HeartContainers)
	updateHearts(player.components.stats_component.currentHealth)
