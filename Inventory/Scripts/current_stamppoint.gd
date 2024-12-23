extends Sprite2D


# Variáveis para controlar o tremor
var shake_duration: float = 0.5  # Duração do tremor em segundos
var shake_magnitude: float = 10.0  # Amplitude do tremor
var shake_timer: float = 0.0  # Temporizador do tremor
var original_position: Vector2

func _ready():
	# Salva a posição original do sprite
	original_position = position

func _process(delta: float) -> void:
	# Verifica se estamos em tremor
	if shake_timer > 0:
	# Gera uma nova posição aleatória para o tremor
		position = original_position + Vector2(
			randf_range(-shake_magnitude, shake_magnitude),
			randf_range(-shake_magnitude, shake_magnitude)
		)
		shake_timer -= delta
	else:
		# Reseta a posição quando o tremor termina
		position = original_position

func start_shake():
	shake_timer = shake_duration

#
#
#var tween_values = [0.0, 20.0]
#
#func _enter_tree():
	#pass
#
#func _ready():
	#start_tween()
#
#func start_tween():
	#var tween = get_tree().create_tween()
	#tween.tween_property(self, "offset", Vector2(100.0,100.0), 2.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	#tween.tween_property(self, "offset", Vector2(1.0,1.0), 2.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	##tween.tween_(self, "offset:y", tween_values[0], tween_values[1], 1.0)
	#
#
#func on_tween_completed(object, key):
	#tween_values.invert()
	#start_tween()
