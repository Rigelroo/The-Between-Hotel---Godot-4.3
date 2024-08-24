extends CanvasLayer

@onready var slots: Array = %HBoxContainer.get_children()
var currently_selected: int = 0
@onready var selector = %CenterContainer

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("selector_right"):
		move_selector_R()
	if Input.is_action_just_pressed("selector_left"):
		move_selector_L()
	if Input.is_action_just_pressed("Interact"):
		select()
func _ready() -> void:
	
	$Control/VideoStreamPlayer.play()
	$Timer.start(5)
	

func _on_timer_timeout() -> void:
	
	$AnimationPlayer2.play("new_animation")
	
	$AnimationPlayer.play("new_animation")
	
	
func continuegame():
	SceneManager.transition_to("res://scenes/entry_hallNode.tscn")
func closegame():
	get_tree().quit()
	
func select():
	if currently_selected == 0:
		continuegame()
	elif currently_selected == 1:
		closegame()
func move_selector_R():
	
	currently_selected = (currently_selected + 1) % slots.size()
	selector.global_position = slots[currently_selected].global_position
	
func move_selector_L():
	
	currently_selected = (currently_selected - 1) % slots.size()
	selector.global_position = slots[currently_selected].global_position
