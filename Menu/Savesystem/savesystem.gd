extends Node


# Define o número máximo de saves
const MAX_SAVES: int = 3
const SAVEGAME_PREFIX: String = "user://savegame"
const CONFIG_PREFIX: String = "user://config"
const SCENESTATE_PREFIX: String = "user://scenestate"
const ENCRYPTION_PASSWORD: String = "OUROBOROS"

# Dados iniciais para salvamento
var pos_dict = {}
var signalManager_dict = {}
var equiped_stamps = {}
var inv_stamps = {}
var inv_items = {}
var inv_item_amounts = {}
var somconfig_dict = {}
var telaconfig_dict = {}
var controlesconfig_dict = {}
var languageconfig_dict = {}
var saved_current_scene: String = ""
var stored_scene = null
var lifepoints = null
var Deathsnumber = null
var saved_current_scenename = null
var scene_states = {}
var missions_array = {}

func _ready() -> void:
	pass
	#SignalManager.its_saving.connect(save_game)

func save_object_state(scene_name: String, object_name: String, object_data: Dictionary):
	if !scene_states.has(scene_name):
		scene_states[scene_name] = {}  # Cria um novo estado para a cena, se necessário

	# Salva os dados do objeto no estado da cena
	scene_states[scene_name][object_name] = object_data
	print("Estado do objeto '%s' na cena '%s' salvo: %s" % [object_name, scene_name, object_data])

func save_scene_state(scene_name: String, object_name: String, data: Dictionary):
	# Inicializa o dicionário para a cena, se necessário
	if not scene_states.has(scene_name):
		scene_states[scene_name] = {}
	
	# Salva os dados do objeto no contexto da cena
	scene_states[scene_name][object_name] = data
	print("Estado salvo para o objeto '%s' na cena '%s': %s" % [object_name, scene_name, str(data)])

func load_scene_state(scene_name: String, object_name: String) -> Dictionary:
	# Verifica se há dados salvos para a cena e o objeto
	var null_var = {}
	if scene_states.has(scene_name) and scene_states[scene_name].has(object_name):
		return scene_states[scene_name][object_name]
	else:
		print("Nenhum estado salvo encontrado para o objeto '%s' na cena '%s'." % [object_name, scene_name])
		return null_var



func save_all_states(scene_name: String, objects: Array):
	for obj in objects:
		if obj.has_method("save"):
			var data = obj.save()  # Assuma que cada objeto retorna seus dados ao chamar 'save'
			save_scene_state(scene_name, obj.name, data)

func load_all_states(scene_name: String, objects: Array):
	for obj in objects:
		if obj.has_method("load_player_state"):
			var data = load_scene_state(scene_name, obj.name)
			obj.load_player_state()
# Função genérica para salvar dados


func save_to_slot(slot: int, data: Dictionary) -> void:
	assert(slot > 0 and slot <= MAX_SAVES, "Slot inválido!")
	var file_path = SAVEGAME_PREFIX + str(slot) + ".save"
	var save_file = FileAccess.open_encrypted_with_pass(file_path, FileAccess.WRITE, ENCRYPTION_PASSWORD)
	var json_string = JSON.stringify(data)
	save_file.store_line(json_string)
	save_file.close()
	print("Dados salvos no slot ", slot, ": ", json_string)

# Função genérica para carregar dados
func load_from_slot(slot: int) -> Dictionary:
	assert(slot > 0 and slot <= MAX_SAVES, "Slot inválido!")
	var file_path = SAVEGAME_PREFIX + str(slot) + ".save"
	if not FileAccess.file_exists(file_path):
		print("Arquivo de salvamento não encontrado no slot ", slot)
		return {}
	var save_file = FileAccess.open_encrypted_with_pass(file_path, FileAccess.READ, ENCRYPTION_PASSWORD)
	var data: Dictionary = {}
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()
		var json = JSON.new()
		if json.parse(json_string) == OK:
			data = json.get_data()
			if data.has("scene_states"):
				scene_states = data["scene_states"]
		else:
			print("Erro ao parsear o JSON do slot ", slot)
	save_file.close()
	return data



# Função para salvar a configuração
func save_config_to_slot(slot: int, config: Dictionary) -> void:
	assert(slot > 0 and slot <= MAX_SAVES, "Slot inválido!")
	var file_path = CONFIG_PREFIX + str(slot) + ".save"
	var config_file = FileAccess.open_encrypted_with_pass(file_path, FileAccess.WRITE, ENCRYPTION_PASSWORD)
	var json_string = JSON.stringify(config)
	config_file.store_line(json_string)
	config_file.close()
	print("Configurações salvas no slot ", slot, ": ", json_string)

# Função para carregar a configuração
func load_config_from_slot(slot: int) -> Dictionary:
	assert(slot > 0 and slot <= MAX_SAVES, "Slot inválido!")
	var file_path = CONFIG_PREFIX + str(slot) + ".save"
	if not FileAccess.file_exists(file_path):
		print("Configurações não encontradas no slot ", slot)
		return {}
	var config_file = FileAccess.open_encrypted_with_pass(file_path, FileAccess.READ, ENCRYPTION_PASSWORD)
	var config_data: Dictionary = {}
	while config_file.get_position() < config_file.get_length():
		var json_string = config_file.get_line()
		var json = JSON.new()
		if json.parse(json_string) == OK:
			config_data = json.get_data()
		else:
			print("Erro ao parsear as configurações do slot ", slot)
	config_file.close()
	return config_data

# Função principal para salvar o jogo
func save_game(slot: int) -> void:
	#SignalManager.save_items()
	SignalManager.save_all_parameters()
	ConfigManager.save_configs()
	SignalManager.its_saving.emit()
	## ordem: save_game(Signalmanager.currentslotnumber) ->  save_items & save_all_parameters & its_saving -> player.save()
	var save_data = {
		"coins": 100,
		"user": "Persi",
		"saved_current_scene": saved_current_scene,
		"position": pos_dict,
		"managervariables": signalManager_dict,
		"equiped_stamps": equiped_stamps,
		"inv_stamps": inv_stamps,
		"inv_items": inv_items,
		"inv_item_amounts": inv_item_amounts,
		"lifepoints" : lifepoints,
		"Deathsnumber" : Deathsnumber,
		"saved_current_scenename": saved_current_scenename,
		"missions_array": missions_array,
		"scene_states": scene_states
	}
	
	save_to_slot(slot, save_data, )

	var config_data = {
		"sons": somconfig_dict,
		"tela": telaconfig_dict,
		"controles": controlesconfig_dict,
		"linguagem": languageconfig_dict
	}
	save_config_to_slot(slot, config_data)

func save_config_only():
	var slot = 1
	var config_data = {
		"sons": somconfig_dict,
		"tela": telaconfig_dict,
		"controles": controlesconfig_dict,
		"linguagem": languageconfig_dict
	}
	save_config_to_slot(slot, config_data)

# Função principal para carregar o jogo
func load_game(slot: int, world_scene) -> void:
	var save_data = load_from_slot(slot)
	
	if save_data.is_empty():
		return
	print("Dados carregados do slot ", slot, ": ", save_data)

	# Carregar dados gerais
	if "saved_current_scene" in save_data:
		stored_scene = save_data["saved_current_scene"]
	if "managervariables" in save_data:
		SignalManager.load_parameters(save_data["managervariables"])
	if "inv_stamps" in save_data:
		SignalManager.load_stampsinventory(save_data["inv_stamps"])
	if "inv_items" in save_data and "inv_item_amounts" in save_data:
		SignalManager.load_itemsinventory(save_data["inv_items"], save_data["inv_item_amounts"])
	if "equiped_stamps" in save_data:
		SignalManager.load_inventory(save_data["equiped_stamps"])
	if "missions_array" in save_data:
		for i in save_data["missions_array"]:
			var quest = save_data["missions_array"]
			SignalManager.task_manager.insert(quest)


	# Atualizar a posição dos nodes
	for i in save_data["position"]:
		var pos = Vector2(save_data["position"][i][0], save_data["position"][i][1])
		if world_scene.get_node(i).has_method("update_pos"):
			world_scene.get_node(i).update_pos(pos)

# Função para exibir dados salvos
func read_save_to_show_stats() -> Array:
	var save_stats = []
	for slot in range(1, MAX_SAVES + 1):
		var save_data = load_from_slot(slot)
		if save_data.is_empty():
			save_stats.append("Slot " + str(slot) + ": Vazio")
		else:
			save_stats.append("Slot " + str(slot) + ": " + str(save_data))
	return save_stats

func get_slot_data(slot: int) -> Dictionary:
	var file_path = "user://savegame%s.save" % str(slot)
	if not FileAccess.file_exists(file_path):
		return {
			"exists": false,
			"saved_current_scene": "Nenhuma cena",
			"position": [0, 0],
			"equiped_stamps": [],
			"coins": 0,
			"user": "Vazio"
		}
	
	var save_gamevar = FileAccess.open_encrypted_with_pass(file_path, FileAccess.READ, "OUROBOROS")
	var slot_data = {}
	while save_gamevar.get_position() < save_gamevar.get_length():
		var json_string = save_gamevar.get_line()
		var json = JSON.new()
		if json.parse(json_string) == OK:
			slot_data = json.get_data()
	save_gamevar.close()

	return slot_data

func delete_scene_state(scene_name: String):
	if scene_states.has(scene_name):
		scene_states.erase(scene_name)
		print("Estado da cena '%s' apagado com sucesso." % scene_name)
	else:
		print("Nenhum estado salvo encontrado para a cena '%s'." % scene_name)

func delete_object_state(scene_name: String, object_name: String):
	if scene_states.has(scene_name):
		if scene_states[scene_name].has(object_name):
			scene_states[scene_name].erase(object_name)
			print("Estado do objeto '%s' na cena '%s' apagado com sucesso." % [object_name, scene_name])
			
			# Remove a cena do dicionário, se não houver mais objetos salvos nela
			if scene_states[scene_name].empty():
				scene_states.erase(scene_name)
		else:
			print("Nenhum estado salvo encontrado para o objeto '%s' na cena '%s'." % [object_name, scene_name])
	else:
		print("Nenhum estado salvo encontrado para a cena '%s'." % scene_name)

func clear_all_states():
	scene_states.clear()
	print("Todos os estados de save foram apagados.")

func destroy_save(slot):
	var file_path = "user://savegame%s.save" % str(slot)
	DirAccess.remove_absolute(file_path)
	
