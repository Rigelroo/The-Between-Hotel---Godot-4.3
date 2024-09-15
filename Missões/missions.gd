extends Resource

class_name Questtask


@export_category("Sistema de progresso")
@export var task_progress : int = 0
@export var max_progress : int = 1
@export var completed: bool = false

@export_category("Recursos")

@export var name : String = ""
@export var showname : String = ""
@export var item_texture : Texture2D
@export var npc_texture : Texture2D
@export var reward_texture : Texture2D  
@export var reward_item : InventoryItem
@export var reward_itemb : InventoryItemb
@export var reward_item_amount : int
@export var reward_itemb_amount : int

@export var item_amount: int = 2


@export var description : String = ""

@export_color_no_alpha var theme_color: Color = Color(1,1,1)
