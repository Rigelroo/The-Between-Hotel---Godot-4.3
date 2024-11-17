extends Node2D

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


func _ready() -> void:
	SignalManager.its_saving.connect(save_game)

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
		"saved_current_scenename": saved_current_scenename
	}
	save_to_slot(slot, save_data)

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
	if "equiped_stamps" in save_data:
		SignalManager.load_inventory(save_data["equiped_stamps"])
	if "inv_stamps" in save_data:
		SignalManager.load_stampsinventory(save_data["inv_stamps"])
	if "inv_items" in save_data and "inv_item_amounts" in save_data:
		SignalManager.load_itemsinventory(save_data["inv_items"], save_data["inv_item_amounts"])

	# Atualizar a posição dos nodes
	for i in save_data["position"]:
		var pos = Vector2(save_data["position"][i][0], save_data["position"][i][1])
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


#
#func get_save_slot_data(slot: int) -> Dictionary:
	#var file_path = "user://savegame%s.save" % str(slot)
	#if not FileAccess.file_exists(file_path):
		#return {
			#"exists": false,
			#"saved_current_scene": "Nenhuma",
			#"position": [0, 0],
			#"equiped_stamps": [],
			#"coins": 0,
			#"user": "Vazio"
		#}
	#
	#var save_gamevar = FileAccess.open_encrypted_with_pass(file_path, FileAccess.READ, "OUROBOROS")
	#var slot_data = {}
	#while save_gamevar.get_position() < save_gamevar.get_length():
		#var json_string = save_gamevar.get_line()
		#var json = JSON.new()
		#if json.parse(json_string) == OK:
			#slot_data = json.get_data()
	#save_gamevar.close()
	#
	#return slot_data


#
#var pos_dict = {}
#var scene_file_dict = {}
#var signalManager_dict = {}
#
#var equiped_stamps = {}
#var inv_stamps = {}
#var inv_items = {}
#var inv_item_amounts = {}
#var somconfig_dict = {}
#var telaconfig_dict = {}
#var controlesconfig_dict = {}
#var languageconfig_dict = {}
#var saved_current_scene : String = ""
#
#func _ready() -> void:
	#SignalManager.its_saving.connect(save_game)
	#signalManager_dict = {
		#"SignalManager": [
			#SignalManager.stamp_points,
			#SignalManager.max_stamp_points,
			#SignalManager.main_manager.greed_equiped,
			#SignalManager.main_manager.hleaf_equiped,
			#SignalManager.main_manager.hatintime_equiped,
			#SignalManager.main_manager.shadowdiver_equiped,
			#SignalManager.main_manager.crimsonfury_equiped,
			#SignalManager.main_manager.frozenheart_equiped,
			#SignalManager.main_manager.ffemblem_equiped
			#]
		#}
	#
#
#func save():
	#var save_dict = {
		#"coins" : 100,
		#"user" : "Persi",
		#"saved_current_scene" : saved_current_scene,
		#"position" : pos_dict,
		#"managervariables" : signalManager_dict,
		#"equiped_stamps" : equiped_stamps,
		#"inv_stamps" : inv_stamps,
		#"inv_items" : inv_items,
		#"inv_item_amounts": inv_item_amounts
	#}
	#return save_dict
#
#func save_configs():
	#var saveconfigs_dict = {
		#"sons" : somconfig_dict,
		#"tela" : telaconfig_dict,
		#"controles" : controlesconfig_dict,
		#"linguagem" : languageconfig_dict
	#}
	#return saveconfigs_dict
#
#
#
#func save_game():
	#
	#var save_gamevar = FileAccess.open_encrypted_with_pass("user://savegame.save", FileAccess.WRITE, "OUROBOROS")
	#var json_string = JSON.stringify(save())
	#
	#print("Save Data: ", json_string)
	#save_gamevar.store_line(json_string)
	#
	#
	#var saveconfig_gamevar = FileAccess.open_encrypted_with_pass("user://config.save", FileAccess.WRITE, "OUROBOROS")
	#var json_config_string = JSON.stringify(save_configs())
	#
	#print("Config Data: ", json_config_string)
	#saveconfig_gamevar.store_line(json_config_string)
#
#var stored_scene = null
#
#
#func load_game(world_scene):
	#if not FileAccess.file_exists("user://savegame.save"):
		#return
		#
	#var save_gamevar = FileAccess.open_encrypted_with_pass("user://savegame.save", FileAccess.READ, "OUROBOROS")
	#
	#while save_gamevar.get_position() < save_gamevar.get_length():
		#var json_string = save_gamevar.get_line()
		#var json = JSON.new()
		#var parse_result = json.parse(json_string)
		#var node_data = json.get_data()
		#print("Node Data: ", node_data)
		#
		#if "saved_current_scene" in node_data:
			#stored_scene = node_data["saved_current_scene"]
		#if "managervariables" in node_data:
			#SignalManager.load_parameters(node_data["managervariables"])
		#if "equiped_stamps" in node_data:
			#SignalManager.load_inventory(node_data["equiped_stamps"])
		#if "inv_stamps" in node_data:
			#SignalManager.load_stampsinventory(node_data["inv_stamps"])
		#if "inv_items" in node_data and "inv_item_amounts" in node_data:
			#SignalManager.load_itemsinventory(node_data["inv_items"], node_data["inv_item_amounts"])
		##SignalManager.load_parameters(node_data["managervariables"])
		##SignalManager.load_inventory(node_data["equiped_stamps"])
		#
		#for i in node_data["position"]:
			#var pos = Vector2(node_data["position"][i][0],node_data["position"][i][1])
			#var invc = node_data["equiped_stamps"]
			#world_scene.get_node(i).update_pos(pos)
			#world_scene.get_node(i).update_inv(invc)
		#print(node_data)
#
#
#
#
#func write_save_scene_state(value, name, scene_name):
	#
	#var state = {}
	#if not state.has(scene_name):
		#state[scene_name] = {}
	#state[scene_name][name] = value
	##state[name] = value
	#var save_gamevar = FileAccess.open_encrypted_with_pass("user://scenestate.save", FileAccess.WRITE, "OUROBOROS")
	#var json_string = JSON.stringify(state)
	#print("Save Data: ", json_string)
	#save_gamevar.store_line(json_string)
#
#func read_save_scene_state():
	## Verifica se o arquivo existe
	#if not FileAccess.file_exists("user://scenestate.save"):
		#print("Arquivo de salvamento não encontrado!")
		#return
	#
	## Abre o arquivo criptografado para leitura
	#var save_gamevar = FileAccess.open_encrypted_with_pass("user://scenestate.save", FileAccess.READ, "OUROBOROS")
	#
	#var state_data = {}
	#
	## Lê todas as linhas do arquivo, pois o JSON pode estar distribuído em várias linhas
	#while save_gamevar.get_position() < save_gamevar.get_length():
		#var json_string = save_gamevar.get_line()  # Lê uma linha do arquivo
		#var json = JSON.new()
		#
		## Faz o parsing do JSON
		#var parse_result = json.parse(json_string)
		#if parse_result == OK:
			#var state = json.get_data()  # Obtém o dicionário de dados do JSON
			#print("Node Data: ", state)
			#
			## A partir daqui, você pode tratar os dados como quiser.
			## Supondo que você queira adicionar esses dados a um dicionário `state_data`, por exemplo:
			#for scene_name in state.keys():
				#if not state_data.has(scene_name):
					#state_data[scene_name] = {}
				#for npc_name in state[scene_name].keys():
					## Aqui você pode processar os dados conforme o seu formato.
					#state_data[scene_name][npc_name] = state[scene_name][npc_name]
		#else:
			#print("Erro ao parsear o JSON!")
	#
	## Fechar o arquivo após terminar a leitura
	#save_gamevar.close()
#
	## Retorna o dicionário com os dados carregados
	#return state_data
#
#func read_save_to_show_stats():
	## Verifica se o arquivo existe
	#if not FileAccess.file_exists("user://scenestate.save"):
		#print("Arquivo de estados 1 não encontrado!")
		#return
	#if not FileAccess.file_exists("user://scenestate2.save"):
		#print("Arquivo de estados 2 não encontrado!")
		#return
	#if not FileAccess.file_exists("user://scenestate3.save"):
		#print("Arquivo de estados 3 não encontrado!")
		#return
	#
	#if not FileAccess.file_exists("user://savegame.save"):
		#print("Arquivo de salvamento 1 não encontrado!")
		#return
	#if not FileAccess.file_exists("user://savegame2.save"):
		#print("Arquivo de salvamento 2 não encontrado!")
		#return
	#if not FileAccess.file_exists("user://savegame3.save"):
		#print("Arquivo de salvamento 3 não encontrado!")
		#return
	## Abre o arquivo criptografado para leitura
	#var savestate_gamevar = FileAccess.open_encrypted_with_pass("user://scenestate.save", FileAccess.READ, "OUROBOROS")
	#var save_gamevar = FileAccess.open_encrypted_with_pass("user://savegame.save", FileAccess.READ, "OUROBOROS")
	#var state_data = {}
	#var state_datab = {}
	#
	## Lê todas as linhas do arquivo, pois o JSON pode estar distribuído em várias linhas
	#while save_gamevar.get_position() < save_gamevar.get_length():
		#var json_string = save_gamevar.get_line()  # Lê uma linha do arquivo
		#var json = JSON.new()
		#
		## Faz o parsing do JSON
		#var parse_result = json.parse(json_string)
		#if parse_result == OK:
			#var state = json.get_data()  # Obtém o dicionário de dados do JSON
			#print("Node Data: ", state)
			#
			## A partir daqui, você pode tratar os dados como quiser.
			## Supondo que você queira adicionar esses dados a um dicionário `state_data`, por exemplo:
			#for scene_name in state.keys():
				#if not state_data.has(scene_name):
					#state_data[scene_name] = {}
				#for npc_name in state[scene_name].keys():
					## Aqui você pode processar os dados conforme o seu formato.
					#state_data[scene_name][npc_name] = state[scene_name][npc_name]
		#else:
			#print("Erro ao parsear o JSON!")
#
	#while savestate_gamevar.get_position() < savestate_gamevar.get_length():
		#var json_stringb = savestate_gamevar.get_line()  # Lê uma linha do arquivo
		#var jsonb = JSON.new()
		#
		## Faz o parsing do JSON
		#var parse_resultb = jsonb.parse(json_stringb)
		#if parse_resultb == OK:
			#var stateb = jsonb.get_data()  # Obtém o dicionário de dados do JSON
			#print("Node Data: ", stateb)
			#
			## A partir daqui, você pode tratar os dados como quiser.
			## Supondo que você queira adicionar esses dados a um dicionário `state_data`, por exemplo:
			#for scene_name in stateb.keys():
				#if not state_datab.has(scene_name):
					#state_datab[scene_name] = {}
				#for npc_name in stateb[scene_name].keys():
					## Aqui você pode processar os dados conforme o seu formato.
					#state_datab[scene_name][npc_name] = stateb[scene_name][npc_name]
		#else:
			#print("Erro ao parsear o JSON!")
	## Fechar o arquivo após terminar a leitura
	#save_gamevar.close()
	#savestate_gamevar.close()
#
	## Retorna o dicionário com os dados carregados
	#return state_data
