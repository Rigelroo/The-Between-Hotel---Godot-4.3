extends Resource

class_name CoinManager

@export_subgroup("Coin System")
@export var coin_number : int
@export var coin_max : int
@export var coin_mult : int = 1

@export_subgroup("Stamp System")
@export var hleaf_equiped : bool = false
@export var hatintime_equiped : bool = false
@export var shadowdiver_equiped : bool = false
@export var crimsonfury_equiped : bool = false
@export var frozenheart_equiped : bool = false
@export var ffemblem_equiped : bool = false


@export_subgroup("Point/meter System")
@export var lifepoints: int = 1
@export var inkpoints: int = 1
@export var lifepoints_max: int = 6
@export var inkpoints_max: int = 6

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
	if coin_mult == 2:
		coin_number += 1 * coin_mult
		insert_coin.emit()
