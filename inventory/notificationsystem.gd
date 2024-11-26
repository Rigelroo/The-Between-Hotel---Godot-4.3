extends Control

var tasks_container = null
var index = 0
@onready var taskpanel_node = preload("res://Missões/taskpanelnotif.tscn")
var mission = null

# Referências aos pontos
var start_position = Vector2(-423.0, 227.5)
var end_position = Vector2(0.0, 227.5)
var pause_time = 2.0 # Tempo de pausa no ponto final



	# Cria o Tween e começa a animação

func _ready() -> void:
	
	$VBoxContainer.position = start_position
	SignalManager.update_quests.connect(update)
	tasks_container = $VBoxContainer.get_children()
	update()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("seila"):
		update()

func update():
	#for i in range(min(SignalManager.task_manager.missions.size(), tasks.size())):
	for i in range(min(SignalManager.task_manager.missions.size(), tasks_container.size())):
		mission = SignalManager.task_manager.missions[i]
		var taskslot = tasks_container[i]
		if mission:
			insert(mission, taskslot)

func insert(mission, container):
		var taskpanel = $VBoxContainer/Taskcontainer/Taskpanel
		#taskpanel_node.instantiate()
		
		# Ensure `projectile` is a valid instance of a node
	#
		#var root = get_tree().root
		#var current_scene = root.get_child(root.get_child_count() - 1)
		#print("add task")
		#
		#container.add_child(taskpanel)
		#taskpanel.set_ready()
		#await taskpanel.set_ready()
		taskpanel.set_everything(mission)
		
		
		animate_control()
		#$AnimationPlayer.play("showtask")
		#await $AnimationPlayer.animation_finished
		#$Timer.start(1.5)
		#await $Timer.timeout
		#$AnimationPlayer.play("hidetask")
		#await $AnimationPlayer.animation_finished
		#$VBoxContainer/Taskcontainer.get_child(0).queue_free()





# Referências aos pontos


@onready var tween = $Tween
@onready var control = $VBoxContainer


func animate_control():
	tween = get_tree().create_tween()
	tween.tween_property(control, "position", end_position, 1.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_interval(1.5)
	tween.tween_property(control, "position", start_position, 1.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(control.get_child(1).get_child(0).queue_free)
	#tween.tween_property(control, "position", start_position, 1.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	
	# Aguarda o movimento de retorno terminar
	await tween.finished
	
	# Recomeça
	#animate_control()
