extends Resource

class_name MainManager
@export_subgroup("Doorcorridors")
@export var floor1_doorlock: Array[bool] = [1,2,3]

#@export var doors_floor1: Array[bool] = [1, 2, 3]
@export var floor2_doorlock: Array[bool] = [1,2,3]

@export_subgroup("Coin System")
@export var coin_number : int
@export var coin_max : int
@export var coin_mult : int = 1
@export var greed_number : int = 1


@export var greed_equiped : bool = false
@export var hleaf_equiped : bool = false
@export var hatintime_equiped : bool = false
@export var shadowdiver_equiped : bool = false
@export var crimsonfury_equiped : bool = false
@export var frozenheart_equiped : bool = false
@export var ffemblem_equiped : bool = false


#@export_subgroup("Point/meter System")
#@export var lifepoints: int = 1
#@export var inkpoints: int = 1
#@export var lifepoints_max: int = 6
#@export var inkpoints_max: int = 6

@export_subgroup("Stats/Juice System")

@export var minInk = 0
@export var maxInk = 20
@export var currentInk: int = maxInk
@export var minHealth = 0
@export var maxHealth = 5
@export var currentHealth: int = 0
@export var currentFurypoints: int = 0

@export_subgroup("Stats/Damage System")
@export var damage_value = 5
@export var damage_max = 5
@export var damage_min = 0
@export var crit_chance = 0.3

signal loaded
signal loadscene

signal inventoryopened
signal inventoryclosed

signal activatestamina
signal deactivatestamina
signal no_hats
signal no_crimson
signal insert_coin




func insert():
	if coin_mult == 1:
		
		coin_number += 1
		insert_coin.emit()
	elif coin_mult == 2:
		coin_number += 1 * coin_mult
		insert_coin.emit()
