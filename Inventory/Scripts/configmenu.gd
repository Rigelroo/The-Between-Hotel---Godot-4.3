extends NinePatchRect

@onready var slots: Array = $VBoxContainer.get_children()
@onready var optionstabs: Array = %OptionsContainer.get_children()
@onready var menu_buttons: Array = $TabContainer.get_children()

#@onready var buttons_menu_number = %OptionsContainer.get_child_count()
@onready var tab = %OptionsContainer
@onready var opttab = $TabContainer
var option_selected: int = 0
var currently_selected: int = 0
@onready var selector = %ConfigCentercontainer
@export var gui : Control
var can_move_selector = true

@export var mainvolume_value = 0
@export var musicvolume_value = 0
@export var sfxvolume_value = 0
@export var mudo = false

@export var screentype_value : int
@export var screentesolution_value = Vector2i(1366,768)
@export var vsync_value = false
@export var telacheia_value = false

@export var screenshader_value = null

func load_configs():
	var configs = ConfigManager.load_configs()
	

func selectioned_press():
	if can_move_selector:
		if option_selected == 0:
			continuegame()
		elif option_selected == 1:
			goto_options()
			set_value_options()
		elif option_selected == 2:
			goto_outchoice()
			set_value_choice()

#func focus():
	#option_selected = 0
	#var options = $VBoxContainer.get_children()
	#options[option_selected].grab_focus()
	

func goto_options():
	if $TabContainer.current_tab == 1:
		cfg_selected = 0
		can_move_selector = false
		option_selected = 0
		can_option = true
		var options = %OptionsContainer.get_children()
		var options_cfg = options[option_selected].get_node("options")
		
		var index = options_cfg.get_children()
		selector.global_position = index[option_selected].global_position
		selector.scale.x = 0.3
		selector.scale.y = 0.3
		change_values(index[cfg_selected])
		match_optiontab(option_selected)

func goto_outchoice():
	if $TabContainer.current_tab == 2:
		can_choice = true
		cfg_selected = 0
		can_move_selector = false
		option_selected = 0
		can_option = true
		var options = $TabContainer/Certeza#.get_children()
		var options_cfg = options.get_node("options")
		var index = options_cfg.get_children()
	
		selector.global_position = index[option_selected].global_position
		selector.scale.x = 0.3
		selector.scale.y = 0.3
		change_values(index[cfg_selected])


func out_options():
	if can_move_selector == false:
		can_choice = false
		can_option = false
		can_move_selector = true
		option_selected = 1
		selector.scale.x = 0.6
		selector.scale.y = 0.6
		cfg_selected = 0
		selector.global_position = slots[option_selected].global_position

func continuegame():
	gui.close()

func closegame():
	get_tree().quit()

func show_options():
	$TabContainer.current_tab = currently_selected

var childs = 3



func move_selector_U():
	if can_move_selector && !can_option:
		var tabcountmax = $TabContainer.get_tab_count() - 1 
		var tab = $TabContainer
		if option_selected == 0:
			option_selected = tabcountmax
			
			opttab.current_tab = option_selected
			
			#currently_selected = (currently_selected - 1) % slots.size()
			selector.global_position = slots[option_selected].global_position
		else:
			option_selected -= 1
			
			opttab.current_tab = option_selected
			selector.global_position = slots[option_selected].global_position
	
	elif $TabContainer.current_tab == 2:
		var options = $TabContainer/Certeza.get_node("options")
		var optcountmax = $TabContainer/Certeza.get_child_count() - 1
		var index = options.get_children()
		can_choice = true
		if cfg_selected == 0:
			cfg_selected = optcountmax
		
		
		#currently_selected = (currently_selected - 1) % slots.size()
			selector.global_position = index[cfg_selected].global_position
		else:
			cfg_selected -= 1
			selector.global_position = index[cfg_selected].global_position
		change_values(index[cfg_selected])
	elif can_option:
		move_option_selector_U()

func set_value_choice():
		var options = $TabContainer/Certeza.get_node("options")
		var optcountmax = $TabContainer/Certeza.get_child_count() - 1
		var index = options.get_children()
		can_choice = true
		change_values(index[cfg_selected])

func set_value_options():
	var options = %OptionsContainer.get_children()
	var options_cfg = options[optiontab_selected].get_node("options")
	var optcountmax = options_cfg.get_child_count() - 1
	var index = options_cfg.get_children()
	change_values(index[cfg_selected])

func move_selector_D():
	if can_move_selector && !can_option:
		var tabcountmax = $TabContainer.get_tab_count() - 1
		
		if option_selected == tabcountmax:
			option_selected = 0
			
			opttab.current_tab = option_selected
			#currently_selected = (currently_selected - 1) % slots.size()
			selector.global_position = slots[option_selected].global_position
		else:
			option_selected += 1
			
			opttab.current_tab = option_selected
			selector.global_position = slots[option_selected].global_position
	
	elif $TabContainer.current_tab == 2:
		var options = $TabContainer/Certeza.get_node("options")
		
		var optcountmax = $TabContainer/Certeza.get_child_count() - 1
		var index = options.get_children()
		can_choice = true
		if cfg_selected == optcountmax:
			cfg_selected = 0
		
		
		#currently_selected = (currently_selected - 1) % slots.size()
			selector.global_position = index[cfg_selected].global_position
		else:
			cfg_selected += 1
			selector.global_position = index[cfg_selected].global_position
		change_values(index[cfg_selected])
	elif can_option:
		move_option_selector_D()
	

var cfg_selected = 0
var optiontab_selected = 0

func move_option_selector_U():
	var options = %OptionsContainer.get_children()
	var options_cfg = options[optiontab_selected].get_node("options")
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
	var options = %OptionsContainer.get_children()
	
	var options_cfg = options[optiontab_selected].get_node("options")
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


var can_option = false


func _on_mainvolumeslider_value_changed(value: float) -> void:
	var valueb = value /10
	AudioServer.set_bus_volume_db(0, linear_to_db(valueb))
	ConfigManager.mainvolume_value = value


func _on_musicvolumeslider_value_changed(value: float) -> void:
	var valueb = value /5
	#AudioServer.set_bus_volume_db(1, valueb)
	AudioServer.set_bus_volume_db(1, linear_to_db(value))
	ConfigManager.musicvolume_value = value

func _on_sfxvolumeslider_value_changed(value: float) -> void:
	var valueb = value /5
	AudioServer.set_bus_volume_db(2, linear_to_db(value))
	ConfigManager.sfxvolume_value = value


func _on_mute_box_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(0,toggled_on)
	ConfigManager.mudo = toggled_on

@onready var options_menu_number = %OptionsContainer.get_child_count() - 1
var current_number = 0

func match_optiontab(option_selected):
	%OptionsContainer.current_tab = optiontab_selected

func show_less_options():
	if optiontab_selected == 0:
		optiontab_selected = options_menu_number
		%OptionsContainer.current_tab = options_menu_number
	else:
		optiontab_selected -= 1
		%OptionsContainer.current_tab = optiontab_selected
	goto_options()
	match_optiontab(option_selected)

func show_more_options():
	if optiontab_selected == options_menu_number:
		optiontab_selected = 0
		%OptionsContainer.current_tab = 0
	else:
		optiontab_selected += 1
		%OptionsContainer.current_tab = optiontab_selected
	goto_options()
	match_optiontab(option_selected)

func _on_button_continue_pressed() -> void:
	option_selected = 0
	opttab.current_tab = option_selected
	selector.global_position = slots[option_selected].global_position


func _on_button_option_pressed() -> void:
	option_selected = 1
	opttab.current_tab = option_selected
	selector.global_position = slots[option_selected].global_position
	goto_options()

func _on_button_out_pressed() -> void:
	option_selected = 2
	opttab.current_tab = option_selected
	selector.global_position = slots[option_selected].global_position

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
var cfg_button_type = 0
var selected_button = null
var increasing = false

var selected_button_value: int:
	set(new_value):
		selected_button.value += 1

var can_choice = false

func _unhandled_input(event):
	
	if %TabContainer.current_tab == 0 and gui.isOpen:
		if Input.is_action_pressed("Attack"):
			if can_choice:
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
				
		if Input.is_action_pressed("Interact"):
			cfg_button_type = 0

#var selected_button: ButtonType  # Substitua 'ButtonType' pelo tipo correto do seu botão

func set_window_properties():
	if selected_button == %Screentypebox:
		on_window_mode_selected(screentypebox.selected)
	if selected_button == %Screenresbox:
		_on_screenres_box_selected(screentypebox.selected)
	
func _decrease_value() -> void:
	selected_button.value -= 1

func _increase_value() -> void:
	selected_button.value += 1


func _on_timer_timeout() -> void:
	pass # Replace with function body.


# Referência ao Tween
@onready var tween = $Tween

# Variáveis para controle
var pulsando = true
var pulsar_tamanho = Vector2(1.5, 1.5) # Tamanho máximo
var duracao = 1.0 # Duração da animação


func iniciar_pulsar(option):
	# Inicia a animação de pulsar
	if pulsando:
		tween.interpolate_property(
			option, 
			"scale", 
			Vector2(1, 1), 
			pulsar_tamanho, 
			duracao, 
			Tween.TRANS_SINE, 
			Tween.EASE_IN_OUT
		)
		tween.interpolate_property(
			option, 
			"scale", 
			pulsar_tamanho, 
			Vector2(1, 1), 
			duracao, 
			Tween.TRANS_SINE, 
			Tween.EASE_IN_OUT,
			duracao
			)
	tween.start()

func parar_pulsar():
	pulsando = false
	tween.stop_all() # Para qualquer animação em andamento

#@onready var config_manager : ConfigManager


func _on_telacheia_box_toggled(toggled_on: bool) -> void:
	if toggled_on:
		ConfigManager.telacheia_value = true
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		ConfigManager.telacheia_value = false
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_vsync_box_toggled(toggled_on: bool) -> void:
	if toggled_on:
		ConfigManager.vsync_value = true
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ADAPTIVE)
	else:
		ConfigManager.vsync_value = false
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)


func _on_button_sim_pressed() -> void:
	get_tree().paused = false
	SceneManager.transition_to("res://Menu/menuprincipal.tscn")


func _on_button_não_pressed() -> void:
	out_options()

@onready var screentypebox: OptionButton = $TabContainer/OptionsContainer/Tela/options/Screentypebox
@onready var screenresbox: OptionButton = $TabContainer/OptionsContainer/Tela/options/Screenresbox


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

func _ready() -> void:
	add_window_mode_items()
	screentypebox.item_selected.connect(on_window_mode_selected)
	loadconfigs()
	#match_optiontab()
	

func on_window_mode_selected(index: int) -> void:
	ConfigManager.screentype_value = index
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
	ConfigManager.screenresolution_value = index

func add_window_mode_items() -> void:
	for resolution in RESOLUTION_DICT:
		screenresbox.add_item(resolution)
	for window_mode in WINDOW_MODE_ARRAY:
		screentypebox.add_item(window_mode)

func saveconfigs():
	ConfigManager.save_configs()

func loadconfigs():
	var saved_configs = ConfigManager.load_configs()
	if saved_configs:
		screentypebox.select(saved_configs["tela"]["screentype_value"])
		screentypebox.emit_signal("item_selected", saved_configs["tela"]["screentype_value"])
		
		screenresbox.select(saved_configs["tela"]["screenresolution"])
		screenresbox.emit_signal("item_selected", saved_configs["tela"]["screenresolution"])
		
		telacheia_box.button_pressed = saved_configs["tela"]["telacheia"]
		vsync_box.button_pressed = saved_configs["tela"]["vsync"]
		telacheia_box.emit_signal("button_pressed", saved_configs["tela"]["telacheia"])
		vsync_box.emit_signal("button_pressed", saved_configs["tela"]["vsync"])
		
		mainvolumeslider.value = saved_configs["sons"]["mainvolume"]
		musicvolumeslider.value = saved_configs["sons"]["musicvolume"]
		sfxvolumeslider.value = saved_configs["sons"]["sfxvolume"]
		mute_box.button_pressed = saved_configs["sons"]["mudo"]
		mainvolumeslider.emit_signal("value_changed", saved_configs["sons"]["mainvolume"])
		musicvolumeslider.emit_signal("value_changed", saved_configs["sons"]["musicvolume"])
		sfxvolumeslider.emit_signal("value_changed", saved_configs["sons"]["sfxvolume"])
		mute_box.emit_signal("pressed",saved_configs["sons"]["mudo"])
	
static func string_to_vector2(string := "") -> Vector2:
	if string:
		var new_string: String = string
		new_string = new_string.erase(0, 1)
		new_string = new_string.erase(new_string.length() - 1, 1)
		var array: Array = new_string.split(", ")

		return Vector2(int(array[0]), int(array[1]))

	return Vector2.ZERO

@onready var mainvolumeslider: HSlider = %mainvolumeslider
@onready var musicvolumeslider: HSlider = %musicvolumeslider
@onready var sfxvolumeslider: HSlider = %sfxvolumeslider
@onready var mute_box: CheckBox = $TabContainer/OptionsContainer/Sons/options/MuteBox

@onready var telacheia_box: CheckBox = $TabContainer/OptionsContainer/Tela/options/TelacheiaBox
@onready var vsync_box: CheckBox = $TabContainer/OptionsContainer/Tela/options/VsyncBox
