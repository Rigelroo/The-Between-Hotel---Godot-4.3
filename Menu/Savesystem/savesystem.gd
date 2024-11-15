extends Node2D



var pos_dict = {}
var scene_file_dict = {}
var signalManager_dict = {}

var equiped_stamps = {}
var inv_stamps = {}
var inv_items = {}
var inv_item_amounts = {}
var somconfig_dict = {}
var telaconfig_dict = {}
var controlesconfig_dict = {}
var languageconfig_dict = {}
var saved_current_scene : String = ""

func _ready() -> void:
	SignalManager.its_saving.connect(save_game)
	signalManager_dict = {
		"SignalManager": [
			SignalManager.stamp_points,
			SignalManager.max_stamp_points,
			SignalManager.main_manager.greed_equiped,
			SignalManager.main_manager.hleaf_equiped,
			SignalManager.main_manager.hatintime_equiped,
			SignalManager.main_manager.shadowdiver_equiped,
			SignalManager.main_manager.crimsonfury_equiped,
			SignalManager.main_manager.frozenheart_equiped,
			SignalManager.main_manager.ffemblem_equiped
			]
		}
	

func save():
	var save_dict = {
		"coins" : 100,
		"user" : "Persi",
		"saved_current_scene" : saved_current_scene,
		"position" : pos_dict,
		"managervariables" : signalManager_dict,
		"equiped_stamps" : equiped_stamps,
		"inv_stamps" : inv_stamps,
		"inv_items" : inv_items,
		"inv_item_amounts": inv_item_amounts
	}
	return save_dict

func save_configs():
	var saveconfigs_dict = {
		"sons" : somconfig_dict,
		"tela" : telaconfig_dict,
		"controles" : controlesconfig_dict,
		"linguagem" : languageconfig_dict
	}
	return saveconfigs_dict



func save_game():
	
	var save_gamevar = FileAccess.open_encrypted_with_pass("user://savegame.save", FileAccess.WRITE, "OUROBOROS")
	var json_string = JSON.stringify(save())
	
	print("Save Data: ", json_string)
	save_gamevar.store_line(json_string)
	
	
	var saveconfig_gamevar = FileAccess.open_encrypted_with_pass("user://config.save", FileAccess.WRITE, "OUROBOROS")
	var json_config_string = JSON.stringify(save_configs())
	
	print("Config Data: ", json_config_string)
	saveconfig_gamevar.store_line(json_config_string)

var stored_scene = null


func load_game(world_scene):
	if not FileAccess.file_exists("user://savegame.save"):
		return
		
	var save_gamevar = FileAccess.open_encrypted_with_pass("user://savegame.save", FileAccess.READ, "OUROBOROS")
	
	while save_gamevar.get_position() < save_gamevar.get_length():
		var json_string = save_gamevar.get_line()
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		var node_data = json.get_data()
		print("Node Data: ", node_data)
		
		if "saved_current_scene" in node_data:
			stored_scene = node_data["saved_current_scene"]
		if "managervariables" in node_data:
			SignalManager.load_parameters(node_data["managervariables"])
		if "equiped_stamps" in node_data:
			SignalManager.load_inventory(node_data["equiped_stamps"])
		if "inv_stamps" in node_data:
			SignalManager.load_stampsinventory(node_data["inv_stamps"])
		if "inv_items" in node_data and "inv_item_amounts" in node_data:
			SignalManager.load_itemsinventory(node_data["inv_items"], node_data["inv_item_amounts"])
		#SignalManager.load_parameters(node_data["managervariables"])
		#SignalManager.load_inventory(node_data["equiped_stamps"])
		
		for i in node_data["position"]:
			var pos = Vector2(node_data["position"][i][0],node_data["position"][i][1])
			var invc = node_data["equiped_stamps"]
			world_scene.get_node(i).update_pos(pos)
			world_scene.get_node(i).update_inv(invc)
		print(node_data)




func write_save_scene_state(value, name, scene_name):
	
	var state = {}
	if not state.has(scene_name):
		state[scene_name] = {}
	state[scene_name][name] = value
	#state[name] = value
	var save_gamevar = FileAccess.open_encrypted_with_pass("user://scenestate.save", FileAccess.WRITE, "OUROBOROS")
	var json_string = JSON.stringify(state)
	print("Save Data: ", json_string)
	save_gamevar.store_line(json_string)

#func read_save_scene_state():
	#if not FileAccess.file_exists("user://scenestate.save"):
		#return
		#
	#var save_gamevar = FileAccess.open_encrypted_with_pass("user://scenestate.save", FileAccess.READ, "OUROBOROS")
	#
	#while save_gamevar.get_position() < save_gamevar.get_length():
		#var json_string = save_gamevar.get_line()
		#var json = JSON.new()
		#var parse_result = json.parse(json_string)
		#var state_data = json.get_data()
		#print("Node Data: ", state_data)
		#var state = {}

		#state_data[]
#func read_save_scene_state(scene_name, npc_name):
	#var state = {}
#
	## Lê o arquivo criptografado
	#var save_gamevar = FileAccess.open_encrypted_with_pass("user://scenestate.save", FileAccess.READ, "OUROBOROS")
	#if save_gamevar:
		#var json_string = save_gamevar.get_as_text()
		#state = JSON.parse(json_string).result  # Deserializa o JSON
#
		#save_gamevar.close()  # Fechando o arquivo após ler
#
	## Retorna o valor do NPC (npc_name) dentro da chave do `scene_name`
	#if state.has(scene_name) and state[scene_name].has(npc_name):
		#return state[scene_name][npc_name]
	#
	#return null  # Caso não encontre o valor
func read_save_scene_state():
	# Verifica se o arquivo existe
	if not FileAccess.file_exists("user://scenestate.save"):
		print("Arquivo de salvamento não encontrado!")
		return
	
	# Abre o arquivo criptografado para leitura
	var save_gamevar = FileAccess.open_encrypted_with_pass("user://scenestate.save", FileAccess.READ, "OUROBOROS")
	
	var state_data = {}
	
	# Lê todas as linhas do arquivo, pois o JSON pode estar distribuído em várias linhas
	while save_gamevar.get_position() < save_gamevar.get_length():
		var json_string = save_gamevar.get_line()  # Lê uma linha do arquivo
		var json = JSON.new()
		
		# Faz o parsing do JSON
		var parse_result = json.parse(json_string)
		if parse_result == OK:
			var state = json.get_data()  # Obtém o dicionário de dados do JSON
			print("Node Data: ", state)
			
			# A partir daqui, você pode tratar os dados como quiser.
			# Supondo que você queira adicionar esses dados a um dicionário `state_data`, por exemplo:
			for scene_name in state.keys():
				if not state_data.has(scene_name):
					state_data[scene_name] = {}
				for npc_name in state[scene_name].keys():
					# Aqui você pode processar os dados conforme o seu formato.
					state_data[scene_name][npc_name] = state[scene_name][npc_name]
		else:
			print("Erro ao parsear o JSON!")
	
	# Fechar o arquivo após terminar a leitura
	save_gamevar.close()

	# Retorna o dicionário com os dados carregados
	return state_data
