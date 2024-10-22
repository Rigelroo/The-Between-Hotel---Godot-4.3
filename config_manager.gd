extends Node


var mainvolume_value = 0
var musicvolume_value = 0
var sfxvolume_value = 0

var screentype_value = null
var screentesolution_value = null
var vsync_value = false
var telacheia_value = false

@onready var ItemStackGuiClass = preload("res://inventory/gui/itemStackGui.tscn")
@onready var ItemStackGuiClassb = preload("res://inventory/gui/itemStackGuib.tscn")
@onready var ItemStackGuiClassc = preload("res://inventory/gui/itemStackGuic.tscn")
@onready var inventory: Inventory = preload("res://inventory/PlayerInventory.tres")
@onready var inventoryb: Inventoryb = preload("res://inventory/PlayerInventoryb.tres")
@onready var inventoryc: Inventoryc = preload("res://inventory/PlayerInventoryc.tres")
@onready var task_manager: TaskManager = preload("res://Global/Task_manager.tres")
@onready var main_manager : MainManager = preload("res://Global/Mainmanager.tres")
var player = null
