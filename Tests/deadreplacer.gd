extends CanvasLayer

@onready var slots: Array = %HBoxContainer.get_children()
var currently_selected: int = 0
@onready var selector = %CenterContainer
var activated = false
@export var chavinho = false
signal Continuegame


func _process(delta: float) -> void:
	if activated:
		if Input.is_action_just_pressed("selector_right"):
			move_selector_R()
		if Input.is_action_just_pressed("selector_left"):
			move_selector_L()
		if Input.is_action_just_pressed("Interact"):
			select()


func _ready() -> void:
	activated = false
	self.visible = false


func activate():
	self.visible = true
	activated = true
	if chavinho:
		$Control/VideoStreamPlayer.play()
	$Timer.start(5)



func _on_timer_timeout() -> void:
	
	$AnimationPlayer2.play("new_animation")
	
	$AnimationPlayer.play("new_animation")
	
	
func continuegame():
	Continuegame.emit()
	SceneManager.transition_to("res://Tests/parallaxtest1.tscn")

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
