extends Node2D

var systemdatetime_dict = {}

@export_file("*.tscn") var first_scene 

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

var is_in_config_tab = false
var is_in_save_tab = false
func move_selector_D():
	if menuslots.size() == 0:
		return
	# Update previous selection
	previously_selected = currently_selected
	# Wrap around to the first button if at the end
	currently_selected = (currently_selected + 1) % menuslots.size()
	# Update button visuals
	if is_in_config_tab:
		change_values(menuslots[currently_selected])
	update_things()

func move_selector_U():
	if menuslots.size() == 0:
		return
	# Update previous selection
	previously_selected = currently_selected
	# Wrap around to the last button if at the beginning
	currently_selected = (currently_selected - 1 + menuslots.size()) % menuslots.size()
	# Update button visuals
	if is_in_config_tab:
		change_values(menuslots[currently_selected])
	update_things()


func move_option_selector_U():
	#var options = %OptionsContainer.get_children()
	var options_cfg = menuslots
	var optcountmax = options_cfg.get_child_count() - 1
	var index = options_cfg.get_children()
	
	if cfg_selected == 0:
		cfg_selected = optcountmax
		
		
		#currently_selected = (currently_selected - 1) % slots.size()
		selector.global_position = index[cfg_selected].global_position
	else:
		cfg_selected -= 1
		
		selector.global_position = index[cfg_selected].global_position
	change_values(index[cfg_selected])
	print(index[cfg_selected])

func move_option_selector_D():
	#var options = %OptionsContainer.get_children()
	
	var options_cfg = menuslots
	var optcountmax = options_cfg.get_child_count() - 1
	var index = options_cfg.get_children()
	if cfg_selected == optcountmax:
		cfg_selected = 0
		
		
		#currently_selected = (currently_selected - 1) % slots.size()
		selector.global_position = index[cfg_selected].global_position
	else:
		cfg_selected += 1
		
		selector.global_position = index[cfg_selected].global_position
	change_values(index[cfg_selected])
	print(index[cfg_selected])

func update_things():
	showtab()
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

	if event.is_action_pressed("Interact"):
		_on_backbutton_pressed()
	if !is_in_config_tab:
		if event.is_action_pressed("selector_right") or event.is_action_pressed("selector_down"):
			move_selector_D()
		
		elif event.is_action_pressed("selector_left") or event.is_action_pressed("selector_up"):
			move_selector_U()
			
	if is_in_save_tab:
		if event.is_action_pressed("Climb"):
			_on_apagarsave_pressed()

			
	if is_in_config_tab:
		if event.is_action_pressed("inventory_less"):
			show_less_options()
		if event.is_action_pressed("inventory_more"):
			show_more_options()


		if event.is_action_pressed("selector_down"):
			move_selector_D()
		
		elif event.is_action_pressed("selector_up"):
			move_selector_U()


	if event.is_action_pressed("Attack") or event.is_action_pressed("Jump"):
		press_button()

	if is_in_config_tab:
		if Input.is_action_pressed("Attack"):
			#if can_choice:
				if selected_button.is_in_group("Buttonchoices"):
					selected_button.pressed.emit()
		if Input.is_action_pressed("selector_left"):
			if cfg_button_type == 4:
				selected_button.selected -= 1
					
				on_window_mode_selected(selected_button.selected)
		if Input.is_action_pressed("selector_right"):
			if cfg_button_type == 4:
					
				selected_button.selected += 1
				on_window_mode_selected(selected_button.selected)

		if cfg_button_type == 1:
			if Input.is_action_pressed("selector_left"):
				if cfg_button_type == 4:
					screentypebox.selected -= 1
					set_window_properties()
					#on_window_mode_selected(screentypebox.selected)
					
				for i in 100:
					if cfg_button_type == 1:
						if !Input.is_action_pressed("selector_left"):
							break
						await get_tree().create_timer(0.01).timeout
						selected_button.value -= 1
					else: break

			if Input.is_action_pressed("selector_right"):
				if cfg_button_type == 4:
					
					screentypebox.selected += 1
					on_window_mode_selected(screentypebox.selected)
				for i in 100:
					if cfg_button_type == 1:
						if !Input.is_action_pressed("selector_right"):
							break
						await get_tree().create_timer(0.01).timeout
						selected_button.value += 1
					else: break
		if cfg_button_type == 2:
			if Input.is_action_pressed("Attack"):
				selected_button.button_pressed = !selected_button.button_pressed
		if cfg_button_type == 3:
			if Input.is_action_pressed("Attack"):
				selected_button.pressed.emit()


func showtab():
	if currently_selected <= %saveshowtabcontainer.get_child_count():
		%saveshowtabcontainer.current_tab = currently_selected

func _process(delta: float) -> void:
	pass

func _ready() -> void:
	update_all_slots()
	update_things()
	selected_button = menuslots[currently_selected]
	selector.set_global_position(Vector2(213.0,51.0),true)
	festivo()
	match_curtab()
	



func match_curtab():
	match current_tab:
		0: #"menu"
			is_in_config_tab = false
			is_in_save_tab = false
			#%submenuTabcontainer.current_tab = current_tab
			%submenuTabcontainer.current_tab = 0
			menuslots = %menuoptionsContainer.get_children()
			update_things()
		1: #"saves"
			is_in_config_tab = false
			is_in_save_tab = false
			%submenuTabcontainer.current_tab = 0
			menuslots = %saveslots.get_children()
			update_things()
			is_in_save_tab = true
		2: #"configs"
			is_in_config_tab = true
			is_in_save_tab = false
			%submenuTabcontainer.current_tab = 1
			menuslots = %OptionsContainer.get_child(current_option_menu).find_child("options").get_children()
			update_things()
		3: #"out"
			is_in_config_tab = false
			is_in_save_tab = false
			%submenuTabcontainer.current_tab = 2
			menuslots = %options.get_children()
			update_things()
	
var current_option_menu = 0


func festivo():
	systemdatetime_dict = Time.get_datetime_dict_from_system()
	
	print(systemdatetime_dict)
	if systemdatetime_dict.month == 12:
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
	elif systemdatetime_dict.month != 12 and systemdatetime_dict.month != 10:
		$MenuprincipalFundo/festivoshadow.visible = false
		$Menuprincipalcaixa/festivo2.visible = false
		$Menuprincipalcaixa/festivo3.visible = false
		#$MenuprincipalFundo/festivo.texture = 


func loadscene():
	pass



func update_all_slots():
	var tab = null
	var valor = -1
	for i in range(1,4):  # Três slots, por exemplo
		valor += 1
		tab = %saveshowtabcontainer.get_child(valor)
		var savelocationlabel = tab.savelocationlabel
		var lifelabel = tab.lifelabel
		var deathslabel = tab.deathslabel
		var coinslabel = tab.coinslabel
		var ultimosavelabel = tab.ultimosavelabel
		var tempolabel = tab.tempolabel
		var emptycoiso = tab.empty
		var apagarsave = tab.apagarsave
		var print_texturerect = tab.print_texturerect
		update_slot_display(i, savelocationlabel, lifelabel, deathslabel, coinslabel, ultimosavelabel, tempolabel, emptycoiso, apagarsave)
		load_slot_screenshot(i, print_texturerect)
	valor = 0



func update_slot_display(slot: int, scene_label: Label, lifelabel, deathslabel, coinslabel, ultimosavelabel, tempolabel, emptycoiso, apagarsave):
	var slot_data = SaveSys.get_slot_data(slot)
	
	if slot_data.has("exists"):
		scene_label.text = "Vazio"
		#position_label.text = "Posição: N/A"
		lifelabel.text = "N/A"
		deathslabel.text = "N/A"
		coinslabel.text = "N/A"
		ultimosavelabel.text = "N/A"
		tempolabel.text = "N/A"
		emptycoiso.visible = true
		apagarsave.visible = false
		#items_label.text = "Itens Equipados: N/A"
		return

	# Atualizar os Labels com dados do slot
	#scene_label.text = "Cena: %s" % slot_data.get("saved_current_scene", "Desconhecida")
	
	var lastscene_name = slot_data.get("saved_current_scenename", "Desconhecida")
	if lastscene_name:
		scene_label.text = lastscene_name
	
	#savelocationlabel.text = slot_data.get("saved_current_scene", "Desconhecida")
	lifelabel.text = "N/A"
	deathslabel.text = "N/A"
	coinslabel.text = str(slot_data.get("coins", "N/A"))
	ultimosavelabel.text = "N/A"
	tempolabel.text = "0h 0min"
	emptycoiso.visible = false
	apagarsave.visible = true
	#var pos = slot_data.get("position", [0, 0])
	#position_label.text = "Posição: (%s, %s)" % [str(pos[0]), str(pos[1])]
	
	#var items = slot_data.get("equiped_stamps", [])
	#items_label.text = "Itens Equipados: %s" % (", ".join(items))
func load_slot_screenshot(slot: int, texture_rect: TextureRect) -> void:
	var file_path = "user://slot%s_screenshot.png" % str(slot)
	if FileAccess.file_exists(file_path):
		var img = Image.load_from_file(file_path)
		var texture = ImageTexture.create_from_image(img)
		texture_rect.texture = texture
		print("Screenshot carregada para o slot %s" % slot)
	else:
		texture_rect.texture = null
		print("Nenhuma screenshot encontrada para o slot %s" % slot)


func _on_playsave_pressed() -> void:
	var save_slot = null
	if currently_selected >= 0 and currently_selected < 3:
		save_slot = currently_selected + 1
	elif currently_selected >= 3:
		save_slot = currently_selected - 1
	var save = SaveSys.load_from_slot(save_slot)
	print(SaveSys.load_from_slot(save_slot))
	if save.has("saved_current_scene"):
		if save["saved_current_scene"]:
			SignalManager.currentsaveslot = save_slot 
			SignalManager.first_sceme = true
			SceneManager.transition_to(save["saved_current_scene"])
	else:
		SignalManager.currentsaveslot = save_slot 
		SignalManager.first_sceme = true
		SceneManager.transition_to(first_scene)

func _on_apagarsave_pressed() -> void:
	delete_options.visible = true
	menuslots = delete_options.get_child(1).get_children()
	

func _on_button_delete_sim_pressed() -> void:
	var save_slot = null
	if currently_selected >= 0 and currently_selected < 3:
		save_slot = currently_selected + 1
	elif currently_selected >= 3:
		save_slot = currently_selected - 1
	SaveSys.destroy_save(save_slot)
	delete_options.visible = false
	menuslots = %saveslots.get_children()

func _on_button_delete_não_pressed() -> void:
	delete_options.visible = false
	menuslots = %saveslots.get_children()

@onready var delete_options: Control = $Menuprincipalcaixa/submenuTabcontainer/save_control/delete_options

func _on_save_1_pressed() -> void:
	currently_selected = 0
	showtab()
	#
	#var save_slot = 1
	#var save = SaveSys.load_from_slot(save_slot)
	#print(SaveSys.load_from_slot(save_slot))
	#if save.has("saved_current_scene"):
		#if save["saved_current_scene"]:
			#SignalManager.currentsaveslot = save_slot 
			#SignalManager.first_sceme = true
			#SceneManager.transition_to(save["saved_current_scene"])
		#else:
			#SignalManager.currentsaveslot = save_slot
			#SignalManager.first_sceme = true
			#SceneManager.transition_to(first_scene)
	#else:
		#SignalManager.currentsaveslot = save_slot 
		#SignalManager.first_sceme = true
		#SceneManager.transition_to(first_scene)

func _on_save_2_pressed() -> void:
	currently_selected = 1
	showtab()
	#var save_slot = 2
#
	#var save = SaveSys.load_from_slot(save_slot)
	#print(SaveSys.load_from_slot(save_slot))
	#if save.has("saved_current_scene"):
		#if save["saved_current_scene"]:
			#SignalManager.currentsaveslot = save_slot 
			#SignalManager.first_sceme = true
			#SceneManager.transition_to(save["saved_current_scene"])
	#else:
		#SignalManager.currentsaveslot = save_slot 
		#SignalManager.first_sceme = true
		#SceneManager.transition_to(first_scene)

func _on_save_3_pressed() -> void:
	currently_selected = 2
	showtab()
	#var save_slot = 3
#
	#var save = SaveSys.load_from_slot(save_slot)
	#print(SaveSys.load_from_slot(save_slot))
	#if save.has("saved_current_scene"):
		#if save["saved_current_scene"]:
			#SignalManager.currentsaveslot = save_slot 
			#SignalManager.first_sceme = true
			#SceneManager.transition_to(save["saved_current_scene"])
	#else:
		#SignalManager.currentsaveslot = save_slot 
		#SignalManager.first_sceme = true
		#SceneManager.transition_to(first_scene)


func _on_button_carregar_pressed() -> void:
	currently_selected = 0
	$AnimationPlayer.play("apertado")
	current_tab = 1
	update_things()


func _on_button_config_pressed() -> void:
	currently_selected = 0
	$AnimationPlayer.play("apertado")
	current_tab = 2
	update_things()


func _on_button_sair_pressed() -> void:
	currently_selected = 0
	current_tab = 3
	$AnimationPlayer.play("apertado")
	update_things()
	selector.set_global_position((selected_button.global_position),true)


func _on_backbutton_pressed() -> void:
	ConfigManager
	if current_tab != 0:
		currently_selected = 0
		current_tab = 0
		$AnimationPlayer.play("desapertado")
		update_things()
		selector.set_global_position((selected_button.global_position),true)

func _on_button_sim_pressed() -> void:
	get_tree().quit()


func _on_button_não_pressed() -> void:
	currently_selected = 0
	current_tab = 0
	$AnimationPlayer.play("desapertado")
	update_things()
	#out_options()

func intro(): #é só pra identificar como sendo uma cena "não jogável"
	pass


func _on_mainvolumeslider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, value/5)

func _on_musicvolumeslider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(1, value/5)

func _on_sfxvolumeslider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(2, value/5)

func _on_mute_box_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(0,toggled_on)

func change_values(config_button):
	if config_button is HSlider:
		cfg_button_type = 1
		selected_button = config_button
	elif config_button is CheckBox:
		cfg_button_type = 2
		selected_button = config_button
	elif config_button.is_in_group("Buttonchoices"):
		cfg_button_type = 3
		selected_button = config_button
		
	elif config_button is OptionButton:
		cfg_button_type = 4
		selected_button = config_button


func on_window_mode_selected(index: int) -> void:
	match index:
		0: #FULLSCREEN
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		1: #WINDOW MODE
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		2: #BORDERLESS WINDOW
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		3: #BORDERLESS FULLSCREEN
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)

func _on_screenres_box_selected(index):
	var ID = screenresbox.get_item_text(index)
	get_window().set_size(RESOLUTION_DICT[ID])
	ConfigManager.screentesolution_value = RESOLUTION_DICT[ID]

func add_window_mode_items() -> void:
	for resolution in RESOLUTION_DICT:
		screenresbox.add_item(resolution)
	for window_mode in WINDOW_MODE_ARRAY:
		screentypebox.add_item(window_mode)

@onready var screentypebox: OptionButton = %Screentypebox
@onready var screenresbox: OptionButton = %Screenresbox


const WINDOW_MODE_ARRAY : Array[String] = [
	"Full-Screen",
	"Window Mode",
	"Borderless Window",
	"Borderless Full-Screen"
	]

var RESOLUTION_DICT : Dictionary = {
	"800x600": Vector2i(800,600),
	"1600x900": Vector2i(1600,900),
	"1366x768": Vector2i(1366,768),
	"1280x720": Vector2i(1280,720),
	"2560x1140": Vector2i(2560,1140),
	"1920x1080": Vector2i(1920,1080)
}


func set_window_properties():
	if selected_button == %Screentypebox:
		on_window_mode_selected(screentypebox.selected)
	if selected_button == %Screenresbox:
		_on_screenres_box_selected(screentypebox.selected)
	
func _decrease_value() -> void:
	selected_button.value -= 1

func _increase_value() -> void:
	selected_button.value += 1

var options_menu_number = 0

func show_less_options():
	var tabnumbers = %OptionsContainer.get_child_count() - 1
	if current_option_menu == 0:
		current_option_menu = options_menu_number
		%OptionsContainer.current_tab = options_menu_number
	else:
		current_option_menu -= 1
		%OptionsContainer.current_tab = current_option_menu
	goto_options()

func show_more_options():
	var tabnumbers = %OptionsContainer.get_child_count() - 1
	if current_option_menu == tabnumbers:
		current_option_menu = 0
		%OptionsContainer.current_tab = 0
	else:
		current_option_menu += 1
		%OptionsContainer.current_tab = current_option_menu
	goto_options()

func goto_options():
	if %submenuTabcontainer.current_tab == 1:
		currently_selected = 0
		option_selected = 0
		menuslots = %OptionsContainer.get_child(current_option_menu).find_child("options").get_children()
		update_things()
		selector.global_position = menuslots[currently_selected].global_position
		selector.scale.x = 0.3
		selector.scale.y = 0.3
		change_values(menuslots[currently_selected])
