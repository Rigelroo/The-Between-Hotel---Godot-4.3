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
		taskpanel = $VBoxContainer/Taskcontainer/Taskpanel
		if mission.first_quest:
			taskpanel.set_everything(mission)
		
			animate_control()
			mission.first_quest = false





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
