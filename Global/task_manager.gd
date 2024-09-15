extends Resource

class_name TaskManager

@export var missions: Array[Questtask] = []

func insert(quest: Questtask):
	for i in range(missions.size()):
		if !missions[i] == null:
			if missions[i].name == quest.name:
				print("already have")
				break
		else:
			missions[i] = quest
			SignalManager.update_quests.emit()
			break
			
		
