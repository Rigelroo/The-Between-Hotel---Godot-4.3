extends Area2D

@export_file("*.mp3") var sound : Array[String]
var is_in_area = false
var chance = 0.4
var pim_times = 0
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Interact") && is_in_area:
		pim_times += 1
		if pim_times == 10:
			var special_sound = chance > randf()
			if special_sound:
				var sound_load = load(sound[2])
				$Bellsound.set_stream(sound_load)
				$Bellsound.play()
				pim_times = 0
			else:
				var sound_load = load(sound[1])
				$Bellsound.set_stream(sound_load)
				$Bellsound.play()
				pim_times = 0
		else: 
			var sound_load = load(sound[0])
			$Bellsound.set_stream(sound_load)
			$Bellsound.play()
			


func _on_area_entered(area: Area2D) -> void:
	if area.owner.is_in_group("Player"):
		is_in_area = true

func _on_area_exited(area: Area2D) -> void:
	if area.owner.is_in_group("Player"):
		is_in_area = false
