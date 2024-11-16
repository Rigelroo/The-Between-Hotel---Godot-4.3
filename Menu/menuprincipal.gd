extends Node2D

var systemdatetime_dict = {}



@export_file("*.png") var festivosprites : Array[String]

@onready var menuslots: Array = %menuoptionsContainer.get_children()
@onready var selector = %ConfigCentercontainer
@export var gui : Control
var can_move_selector = true
var can_option = true
var option_selected: int = 0
#var currently_selected: int = 0
#var previously_selected: int = -1

var current_tab: int = 0:
	set(new_value):
		current_tab = new_value
		
		match_curtab()


##current tab 0 = menu / current tab 0 = saves / current tab 0 = configs / current tab 0 = sair

@onready var menuoptions_container: Control = %menuoptionsContainer


var cfg_selected = 0
var optiontab_selected = 0
var cfg_button_type = 0
var selected_button = null
var past_selected_button = null

var buttonsprite = null
var pastbuttonsprite = null
var pulsate = false

var currently_selected = 0
var previously_selected = 0


func move_selector_D():
	if menuslots.size() == 0:
		return
	# Update previous selection
	previously_selected = currently_selected
	# Wrap around to the first button if at the end
	currently_selected = (currently_selected + 1) % menuslots.size()
	# Update button visuals
	update_things()

func move_selector_U():
	if menuslots.size() == 0:
		return
	# Update previous selection
	previously_selected = currently_selected
	# Wrap around to the last button if at the beginning
	currently_selected = (currently_selected - 1 + menuslots.size()) % menuslots.size()
	# Update button visuals
	update_things()

func update_things():
	# Get currently and previously selected buttons
	selected_button = menuslots[currently_selected]
	past_selected_button = menuslots[previously_selected]

	# Safely get child nodes for scaling (assuming the first child is the sprite)
	var buttonsprite = selected_button.get_child(0) if selected_button else null
	var pastbuttonsprite = past_selected_button.get_child(0) if past_selected_button else null

	# Move the selector to the new button position
	if selector and selected_button:
		print(selected_button.name)
		selector.global_position = selected_button.global_position

	# Apply scaling animation
	button_pulse(buttonsprite, pastbuttonsprite)

	# Debugging info
	print("Selected:", selected_button.name if selected_button else "None")
	print("Previous:", past_selected_button.name if past_selected_button else "None")

#func button_pulse(buttonsprite, pastbuttonsprite):
	#if buttonsprite and pastbuttonsprite:
		#var tween = get_tree().create_tween()
		#var saved_pbscale = pastbuttonsprite.scale.x
		#var saved_bscale = buttonsprite.scale.x
		#var new_bscale = saved_bscale + 0.2
		## Grow the currently selected button
		#tween.tween_property(buttonsprite, "scale", Vector2(new_bscale, new_bscale), 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
		## Shrink the previously selected button back to normal
		#tween.tween_property(pastbuttonsprite, "scale", Vector2(saved_pbscale, saved_pbscale), 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
		
# Dictionary to store the original scales of all buttons
var original_scales = {}

func button_pulse(buttonsprite, pastbuttonsprite):
	if buttonsprite and pastbuttonsprite:
		# Ensure original scales are stored
		if not original_scales.has(buttonsprite):
			original_scales[buttonsprite] = buttonsprite.scale
		if not original_scales.has(pastbuttonsprite):
			original_scales[pastbuttonsprite] = pastbuttonsprite.scale

		# Retrieve the reference scales
		var base_bscale = original_scales[buttonsprite]
		var base_pbscale = original_scales[pastbuttonsprite]

		# Define scaling factors
		var grow_factor = 1.2  # Grow 20% larger
		var normal_factor = 1.0  # Original size

		# Calculate target scales based on reference
		var new_bscale = base_bscale * grow_factor  # Grow proportionally
		var normal_pbscale = base_pbscale * normal_factor  # Restore to original

		# Create a new tween
		var tween = get_tree().create_tween()

		# Stop any existing animations on these nodes (if needed)
		#tween.stop_all()

		# Animate the current button (grow)
		tween.tween_property(buttonsprite, "scale", new_bscale, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

		# Animate the previous button (shrink back to normal)
		tween.tween_property(pastbuttonsprite, "scale", normal_pbscale, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

func press_button():
	selected_button.pressed.emit()

func _unhandled_input(event):
	if menuslots.size() == 0:
		return

	if event.is_action_pressed("selector_right") or event.is_action_pressed("selector_down"):
		move_selector_D()
	elif event.is_action_pressed("selector_left") or event.is_action_pressed("selector_up"):
		move_selector_U()
	
	if event.is_action_pressed("Attack") or event.is_action_pressed("Interact"):
		press_button()

func _process(delta: float) -> void:
	pass

func _ready() -> void:
	update_things()
	selected_button = menuslots[currently_selected]
	selector.set_global_position(Vector2(213.0,51.0),true)
	festivo()
	match_curtab()
	



func match_curtab():
	match current_tab:
		0: #"menu"
			#%submenuTabcontainer.current_tab = current_tab
			%submenuTabcontainer.current_tab = 0
			menuslots = %menuoptionsContainer.get_children()
			update_things()
		1: #"saves"
			%submenuTabcontainer.current_tab = 0
			menuslots = %saveslots.get_children()
			update_things()
		2: #"configs"
			pass
		3: #"out"
			%submenuTabcontainer.current_tab = 1
			menuslots = %options.get_children()
			update_things()
	

func festivo():
	systemdatetime_dict = Time.get_datetime_dict_from_system()
	
	print(systemdatetime_dict)
	if systemdatetime_dict.month == 11:
		$MenuprincipalFundo/festivoshadow/festivo.texture = load(festivosprites[0])
		$MenuprincipalFundo/festivoshadow.position.x = 470.224
		$MenuprincipalFundo/festivoshadow.position.y = 920.0
		$MenuprincipalFundo/festivoshadow.scale.x = 1
		$MenuprincipalFundo/festivoshadow.scale.y = 1
		
		$MenuprincipalFundo/festivoshadow.visible = true
		$Menuprincipalcaixa/festivo2.visible = true
		$Menuprincipalcaixa/festivo3.visible = true
	if systemdatetime_dict.month == 10:
		$MenuprincipalFundo/festivoshadow/festivo.texture = load(festivosprites[1])
		$MenuprincipalFundo/festivoshadow.position.x = 3441.031
		$MenuprincipalFundo/festivoshadow.position.y = -851.282
		$MenuprincipalFundo/festivoshadow.scale.x = 0.8
		$MenuprincipalFundo/festivoshadow.scale.y = 0.8
		
		$MenuprincipalFundo/festivoshadow.visible = true
		$Menuprincipalcaixa/festivo2.visible = true
		$Menuprincipalcaixa/festivo3.visible = true
	elif systemdatetime_dict.month != 11 and systemdatetime_dict.month != 10:
		$MenuprincipalFundo/festivoshadow.visible = false
		$Menuprincipalcaixa/festivo2.visible = false
		$Menuprincipalcaixa/festivo3.visible = false
		#$MenuprincipalFundo/festivo.texture = 


func loadscene():
	pass


func _on_button_carregar_pressed() -> void:
	currently_selected = 0
	$AnimationPlayer.play("apertado")
	current_tab = 1
	


func _on_button_config_pressed() -> void:
	pass
	#$AnimationPlayer.play("apertado")


func _on_button_sair_pressed() -> void:
	currently_selected = 0
	current_tab = 3
	$AnimationPlayer.play("apertado")
	update_things()
	selector.set_global_position((selected_button.global_position),true)


func _on_backbutton_pressed() -> void:
	currently_selected = 0
	current_tab = 0
	$AnimationPlayer.play("desapertado")
	update_things()
	selector.set_global_position((selected_button.global_position),true)


func _on_save_1_pressed() -> void:
	pass # Replace with function body.


func _on_save_2_pressed() -> void:
	pass # Replace with function body.


func _on_save_3_pressed() -> void:
	pass # Replace with function body.


func _on_apagarsave_pressed() -> void:
	pass # Replace with function body.

func _on_button_sim_pressed() -> void:
	get_tree().quit()


func _on_button_não_pressed() -> void:
	currently_selected = 0
	current_tab = 0
	$AnimationPlayer.play("desapertado")
	update_things()
	#out_options()
