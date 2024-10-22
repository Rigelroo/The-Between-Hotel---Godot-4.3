extends Node2D



var pos_dict = {}
var signalManager_dict = {}
var equiped_stamps = {}
var somconfig_dict = {}
var telaconfig_dict = {}
var controlesconfig_dict = {}
var languageconfig_dict = {}

func _ready() -> void:
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
		"position" : pos_dict,
		"managervariables" : signalManager_dict,
		"equiped_stamps" : equiped_stamps
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
	SignalManager.its_saving.emit()
	var save_gamevar = FileAccess.open_encrypted_with_pass("user://savegame.save", FileAccess.WRITE, "OUROBOROS")
	var json_string = JSON.stringify(save())
	
	print("Save Data: ", json_string)
	save_gamevar.store_line(json_string)
	
	
	var saveconfig_gamevar = FileAccess.open_encrypted_with_pass("user://config.save", FileAccess.WRITE, "OUROBOROS")
	var json_config_string = JSON.stringify(save_configs())
	
	print("Config Data: ", json_config_string)
	saveconfig_gamevar.store_line(json_config_string)


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
		if "managervariables" in node_data:
			SignalManager.load_parameters(node_data["managervariables"])
		if "equiped_stamps" in node_data:
			SignalManager.load_inventory(node_data["equiped_stamps"])
		#SignalManager.load_parameters(node_data["managervariables"])
		#SignalManager.load_inventory(node_data["equiped_stamps"])
		
		for i in node_data["position"]:
			var pos = Vector2(node_data["position"][i][0],node_data["position"][i][1])
			var invc = node_data["equiped_stamps"]
			world_scene.get_node(i).update_pos(pos)
			world_scene.get_node(i).update_inv(invc)
		print(node_data)

#func load_game():
	#if not FileAccess.file_exists("user://savegame.save"):
		#return
		#
	#var save_game = FileAccess.open_encrypted_with_pass("user://savegame.save", FileAccess.READ, "OUROBOROS")
	#
	#while save_game.get_position() < save_game.get_length():
		#var json_string = save_game.get_line()
		#var json = JSON.new()
		#var parse_result = json.parse(json_string)
		#var node_data = json.get_data()
		#
		#for i in node_data["position"]:
			#var pos = Vector2(node_data["position"][i][0],node_data["position"][i][1])
			#SceneTree.root.get_node(i).update_pos(pos)
		#print(node_data)
