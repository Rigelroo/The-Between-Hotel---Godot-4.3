extends NinePatchRect

var tasks_container = null
var index = 0
@onready var taskpanel_node = preload("res://Missões/taskpanel.tscn")
var mission = null


func _ready() -> void:
	SignalManager.update_quests.connect(update)
	SignalManager.new_taskprogress.connect(update_progress)
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
		var taskpanel = taskpanel_node.instantiate()
		# Ensure `projectile` is a valid instance of a node
	
		var root = get_tree().root
		var current_scene = root.get_child(root.get_child_count() - 1)
		print("add task")
		
		container.add_child(taskpanel)
		taskpanel.set_ready()
		await taskpanel.set_ready()
		taskpanel.set_everything(mission)

func update_progress(task):
	var container = $VBoxContainer.get_children()
	for i in container:
		if i.get_child_count() != 0:
			i.get_child(0).update_progress(task)
