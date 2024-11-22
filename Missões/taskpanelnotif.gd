extends PanelContainer

class_name TaskPanelNotif

@onready var container: CenterContainer = $container
@onready var texture_rect: TextureRect = $container/TextureRect
@onready var itempanel: ItemStackGui = $itempanel
@onready var item: Sprite2D = $itempanel/item
@onready var portrait: Sprite2D = $itempanel/portrait
@onready var missionlabel: Label = $itempanel/Missionlabel
@onready var progress: Control = $itempanel/Progress
@onready var texture_progress_bar: TextureProgressBar = $itempanel/Progress/TextureProgressBar
@onready var namebox: Sprite2D = $itempanel/Progress/TextureProgressBar/Namebox
@onready var progresslabel: Label = %Progresslabel
@onready var progresslabel_2: Label = %Progresslabel2
@onready var objectivelabel: Label = %objectivelabel


@onready var checkbox: Sprite2D = $itempanel/CheckboxContainer/checkbox
@onready var check: Sprite2D = $itempanel/CheckboxContainer/check
@onready var checkcontainer: CenterContainer = $itempanel/CheckboxContainer
@export_color_no_alpha var rect_color: Color = Color(1,1,1)

func set_ready() -> void:
	
	container = $container
	texture_rect = $container/TextureRect
	itempanel = $itempanel
	item = $itempanel/item
	portrait = $itempanel/portrait
	missionlabel = $itempanel/Missionlabel
	progress = $itempanel/Progress
	texture_progress_bar = $itempanel/Progress/TextureProgressBar
	namebox = $itempanel/Progress/TextureProgressBar/Namebox
	progresslabel = $itempanel/Progress/HBoxContainer/Progresslabel
	progresslabel_2 = $itempanel/Progress/HBoxContainer/Progresslabel2
	checkbox = $itempanel/CheckboxContainer/checkbox
	check = $itempanel/CheckboxContainer/check
	checkcontainer = $itempanel/CheckboxContainer
	objectivelabel = $itempanel/Progress/HBoxContainer/objectivelabel


func set_everything(task):
	texture_rect.modulate = task.theme_color
	item.texture = task.item_texture
	portrait.texture = task.npc_texture
	texture_progress_bar.value = task.task_progress
	texture_progress_bar.max_value = task.max_progress
	if !task.reward_texture == null:
		pass
		#reward.texture = task.reward_texture
	missionlabel.text = task.showname
	progresslabel.text = str(task.task_progress)
	objectivelabel.text = str(task.max_progress)

func update_progress(task):
	progresslabel.text = task.task_progress
	objectivelabel.text = task.max_progress
	texture_progress_bar.value = task.task_progress
	if task.task_progress >= task.max_progress:
		checkcontainer.visible = true
		task.completed = true
