extends Control

class_name CoinDisplayer

@export var manager : MainManager
@onready var coinlabel = $Label
func _ready() -> void:
	coinlabel.text = str(SignalManager.coin_number)
	
func update():
	coinlabel.text = str(SignalManager.coin_number) 
