extends Control

class_name InventoryManager

signal opened
signal closed
signal selected

var isOpen: bool = false
@export var SelosisOpen : bool = false

#@onready var ItemStackGuiClass = preload("res://inventory/gui/itemStackGui.tscn")
#@onready var ItemStackGuiClassb = preload("res://inventory/gui/itemStackGuib.tscn")
#@onready var ItemStackGuiClassc = preload("res://inventory/gui/itemStackGuic.tscn")
var inventory: Inventory = load("res://inventory/PlayerInventory.tres")
var inventoryb: Inventoryb = load("res://inventory/PlayerInventoryb.tres")
var inventoryc: Inventoryc = load("res://inventory/PlayerInventoryc.tres")
var slots = null
#@onready var slots: Array = $TabContainer/Selos/GridContainer.get_children() #+ $TabContainer/Selos/Control.get_children()
#
#var sealslots: Array = $TabContainer/Selos/Control.get_children()
#var uslots: Array = $TabContainer/Selos/Control.get_children()
#var invslots: Array = $"TabContainer/Inventário/GridContainer".get_children()

var sealslots = null
var uslots = null
var invslots = null
#@onready var sealbar_slots: Array = $TabContainer/Selos/SealBar.get_children()

@onready var Selos = $"TabContainer/Selos"
@onready var tab = $"TabContainer"
@onready var selector = $TabContainer/Selos/CenterContainer/Slotselect
@onready var selectorb = $"TabContainer/Inventário/CenterContainer/Slotselectb"

@onready var nameLabel = $TabContainer/Selos/NameLabel
@onready var descLabel: RichTextLabel = $TabContainer/Selos/Description
@onready var showSprite = $TabContainer/Selos/ShowSprite
@onready var typelabel: RichTextLabel = $TabContainer/Selos/Typelabel

@onready var current_stamppoint: Sprite2D = $TabContainer/Selos/CurrentStamppoint
@onready var name_label_2: Label = $TabContainer/Selos/CurrentStamppoint/NameLabel2

@onready var show_stamppoint: Sprite2D = $TabContainer/Selos/ShowStamppoint
@onready var stamppointname_label: Label = $TabContainer/Selos/ShowStamppoint/StamppointnameLabel

@onready var nameLabelb = $"TabContainer/Inventário/NameLabelb"
@onready var descLabelb = $"TabContainer/Inventário/Descriptionb"
@onready var showSpriteb = $"TabContainer/Inventário/ShowSpriteb"
@export var number = 0
@onready var coin_displayer = $"TabContainer/Inventário/CoinDisplayer"
var itemInHand: ItemStackGui
@onready var currently_selected: int = 0
var next_selected: int = 1
var previously_selected: int = 0
var nextEmpty: bool
var previousEmpty: bool

@onready var currently_selectedb: int = 0
var next_selectedb: int = 1
var previously_selectedb: int = 0
var nextEmptyb: bool
var previousEmptyb: bool


@export var manager : MainManager

@export_file("*.mp3") var sfx_array : Array[String]

func world_ready():
	pass

func hat_for_selector():
	if manager.hatintime_equiped:
		var random = RandomNumberGenerator.new()
		random.randomize()
		print(random.randi_range(1, 4))
		var randomnumber = random.randi_range(1, 8)
		var hats = {
		1: "res://inventory/gui/Selector/select - hat1.png",
		2: "res://inventory/gui/Selector/select - hat2.png",
		3: "res://inventory/gui/Selector/select - hat3.png",
		4: "res://inventory/gui/Selector/select - hat4.png",
		5: "res://inventory/gui/Selector/select - hat5.png",
		6: "res://inventory/gui/Selector/select - hat6.png",
		7: "res://inventory/gui/Selector/select - hat7.png",
		8: "res://inventory/gui/Selector/select - hat8.png",
		}
		for hatsprite in hats:
			var _index = hats[hatsprite]
			selector.texture = load(hats[randomnumber])
			selectorb.texture = load(hats[randomnumber])
			
func nohats():
	selector.texture = load("res://inventory/gui/Selector/slot inventario - select.png")
	selectorb.texture = load("res://inventory/gui/Selector/slot inventario - select.png")

func stamp_equipped():
	SignalManager.stamp_equippedfunc(slots,currently_selected,SignalManager.inventory)

func stamp_unequipped():
	SignalManager.stamp_unequippedfunc(slots,currently_selected,SignalManager.inventory)

func please_equip():
	SignalManager.equipstamp(slots, sealslots, currently_selected, SignalManager.inventoryc)



func not_enough_stpoints():
	current_stamppoint.start_shake()

func load_items(item):
	SignalManager.load_equipstamp(slots, sealslots, currently_selected, SignalManager.inventoryc, item)
	SignalManager.load_stamp_equippedfunc(slots,currently_selected,SignalManager.inventory, item)
func save_items():
	SignalManager.save_inventory(uslots)

func _ready():
	SignalManager.sigload_equipstamp.connect(Callable(self,"load_items"))
	%Config.show_options()
	SignalManager.its_saving.connect(save_items)
	SignalManager.no_enough_stpoints.connect(not_enough_stpoints)
	SignalManager.stamp_unequipped.connect(stamp_unequipped)
	SignalManager.stamp_equipped.connect(stamp_equipped)
	SignalManager.just_equip.connect(please_equip)
	#SignalManager.inventory.updated.emit()
	selector = $TabContainer/Selos/CenterContainer/Slotselect
	
	slots = $TabContainer/Selos/TabContainer/GridContainer.get_children() + $TabContainer/Selos/TabContainer/GridContainer2.get_children()
	sealslots = $TabContainer/Selos/Control.get_children()
	uslots = $TabContainer/Selos/Control.get_children()
	invslots = $"TabContainer/Inventário/Specialslots".get_children() + $"TabContainer/Inventário/GridContainer".get_children()
	printa()
	hat_for_selector()
	connectSlots()
	SignalManager.inventory.updated.connect(update)
	SignalManager.inventoryb.updated.connect(update)
	SignalManager.inventoryc.updated.connect(update)
	inventory.updated.connect(update)
	inventoryb.updated.connect(update)
	inventoryc.updated.connect(update)
	SignalManager.point_update.connect(update)
	manager.no_hats.connect(nohats)
	manager.insert_coin.connect(updatecoin)
	print("first position",number)
	update()

func printa():
	for j in range(min(SignalManager.inventoryb.invslots.size(), invslots.size())):
		var inventorySlotb: InventorySlotb = SignalManager.inventoryb.invslots[j]
		print(inventorySlotb.item)


func updatecoin():
	coin_displayer.update()

func show_stamppoints():
	print("stamppoints: ", SignalManager.stamp_points)
	name_label_2.set_text(str(SignalManager.stamp_points))
	

func update():
	print("update")
	show_stamppoints()
	for i in range(min(SignalManager.inventory.slots.size(), slots.size())):
		var inventorySlot: InventorySlot = SignalManager.inventory.slots[i]
		
		if !inventorySlot.item:
			slots[i].clear()
			continue
		
		var itemStackGui: ItemStackGui = slots[i].itemStackGui
		
		if !itemStackGui:
			itemStackGui = SignalManager.ItemStackGuiClass.instantiate()
			slots[i].insert(itemStackGui)
		itemStackGui.inventorySlot = inventorySlot
		itemStackGui.update()



	for i in range(min(SignalManager.inventoryc.stampslots.size(), sealslots.size())):
		var inventorySlotc: InventorySlotc = SignalManager.inventoryc.stampslots[i]
		
		if !inventorySlotc.item:
			sealslots[i].clear()
			continue
		
		var itemStackGuic: ItemStackGuic = sealslots[i].itemStackGuic
		
		if !itemStackGuic:
			itemStackGuic = SignalManager.ItemStackGuiClassc.instantiate()
			sealslots[i].insert(itemStackGuic)
		itemStackGuic.inventorySlotc = inventorySlotc
		itemStackGuic.update()

	for j in range(min(SignalManager.inventoryb.invslots.size(), invslots.size())):
		if !invslots[j].get_parent() == $"TabContainer/Inventário/Specialslots":
			var inventorySlotb: InventorySlotb = SignalManager.inventoryb.invslots[j]
			
			if !inventorySlotb.item:
				invslots[j].clear()
				continue
			
			var itemStackGuib: ItemStackGuib = invslots[j].itemStackGuib
			
			if !itemStackGuib:
				itemStackGuib = SignalManager.ItemStackGuiClassb.instantiate()
				invslots[j].insert(itemStackGuib)
			itemStackGuib.inventorySlotb = inventorySlotb
			itemStackGuib.update()


	


func open():
	SignalManager.inventoryopened.emit()
	SignalManager.mouse_visible = true
	SignalManager.can_showmouse = true
	$Parallax2D.visible = true
	visible = true
	isOpen = true
	

func close():
	SignalManager.inventoryclosed.emit()
	SignalManager.can_showmouse = false
	SignalManager.mouse_visible = false
	get_tree().paused = false
	visible = false
	isOpen = false
	
	%Config.saveconfigs()


func readyclose():
	visible = false
	isOpen = false
	#manager.inventoryclosed.emit()






	
	
@onready var greed = GreedStamp





#func stamp_equipped():
	#
	##changetexture_equip()
	#var slot = slots[currently_selected]
	#var secondary = slot.itemStackGui.inventorySlot.item.scriptstr
	#var itemscript = load(secondary).new()
	#print("stamp equip: ",slot.itemStackGui.inventorySlot.item.name)
	#
	#slot = slots[currently_selected]
	#secondary = slot.itemStackGui.inventorySlot.item.scriptstr
	#itemscript = load(secondary).new()
	#
	#
	#itemscript.activatestamp()
	##slots[currently_selected].modulateslot()
	#slot.itemStackGui.inventorySlot.amount = 0
	#print("é esse aqui ó -> ", slots[currently_selected].itemStackGui.inventorySlot.item.name, " num: ",currently_selected)
	#inventory.updated.emit()
	#
	##var texture = slot.itemStackGui.inventorySlot.item.texture
	##var equiptexture = load(terciary)
	##slot.itemStackGui.inventorySlot.item.texture = load(terciary)
	##
#
	##secondary.activatestamp()itemscript

func collect(_inventory: Inventoryc):
	pass
	
func insertItemInSlotEquip(sealslot):
	var item = itemInHand
	
	remove_child(itemInHand)
	itemInHand = null
	
	sealslot.insert(item)

func onSlotClicked(slot):
	var _sealslot = sealslots
	print("clico")
	if slot.isEmpty():
		if !itemInHand: return
		
		insertItemInSlot(slot)
		return
		
	if !itemInHand:
		takeItemFromSlot(slot)
		return
	if slot.itemStackGui.inventorySlot.item.name == itemInHand.inventorySlot.item.name:
		
		stackItems(slot)
		return
		
	swapItems(slot)

func takeItemFromSlot(slot):
	itemInHand = slot.takeItem()
	
	add_child(itemInHand)
	updateItemInHand()

func insertItemInSlot(slot):
	var item = itemInHand
	
	remove_child(itemInHand)
	itemInHand = null
	
	slot.insert(item)

	
#func insertItemInSlot(slot):
	#var item = itemInHand
	#
	#remove_child(itemInHand)
	#itemInHand = null
	#
	#slot.insert(item)

func swapItems(slot):
	var _sealslot = sealslots
	var tempItem = slot.takeItem()
	insertItemInSlot(slot)
	itemInHand = tempItem
	add_child(itemInHand)
	updateItemInHand()
	
	
func stackItems(slot):
	
	var slotItem: ItemStackGui = slot.itemStackGui
	var maxAmount = slotItem.inventorySlot.item.maxAmountInStack
	var totalAmount = slotItem.inventorySlot.amount + itemInHand.inventorySlot.amount
	if slotItem.inventorySlot.amount == maxAmount:
		swapItems(slot)
		return
	if totalAmount <= maxAmount:
		slotItem.inventorySlot.amount = totalAmount
		remove_child(itemInHand)
		itemInHand = null
	else:
		slotItem.inventorySlot.amount = maxAmount
		itemInHand.inventorySlot.amount = totalAmount - maxAmount
	
	slotItem.update()
	if itemInHand: itemInHand.update()
	

func connectSlots():
	for i in range(slots.size()):
		var slot = slots[i]
		slot.index = i
		
		var callable = Callable(onSlotClicked)
		var callable1 = Callable(show_item)
		callable = callable.bind(slot)
		callable1 = callable1.bind(slot)
		slot.pressed.connect(callable)
		slot.pressed.connect(callable1)
		

func updateItemInHand():
	if !itemInHand: return
	itemInHand.global_position = selector.global_position - itemInHand.size / 2

var canOpen_inventory : bool = true

func _exit_tree():
	SignalManager.no_enough_stpoints.disconnect(not_enough_stpoints)
	SignalManager.stamp_unequipped.disconnect(stamp_unequipped)
	SignalManager.stamp_equipped.disconnect(stamp_equipped)
	SignalManager.just_equip.disconnect(please_equip)

func _input(event):
	if Input.is_action_pressed("Magic"):
		hat_for_selector()
	
	if event.is_action_pressed("menu_inventory"):
		if canOpen_inventory:
			if isOpen:
				#SignalManager.stats.visible = true
				close()
			else:
				open()
				#SignalManager.stats.visible = false
	else: pass
	updateItemInHand()
	if event.is_action_pressed("change_menu_mais"):
		var tabcountmax = %TabContainer.get_tab_count()
		var _tabcount = 0
		if tab.current_tab < tabcountmax:
			tab.current_tab += 1
		elif tab.current_tab == tabcountmax:
			tab.current_tab += 1
		print(%TabContainer.get_tab_count())
		#if number < 2 && number > -1:
			#number = number + 1
			#tab.current_tab = number
			#print("position",number)
		#elif number == 2:
			#number = 0
			#tab.current_tab = 0
			#print("position",number)
	
	if event.is_action_pressed("change_menu_menos") :
		var tabcountmax = %TabContainer.get_tab_count()
		
		var _tabcount = 0
		if tab.current_tab < tabcountmax:
			if tab.current_tab != 0:
				print(tab.current_tab)
				tab.current_tab -= 1
		elif tab.current_tab == tabcountmax:
			print(tab.current_tab)
			tab.current_tab -= 1
		print(%TabContainer.get_tab_count())
		#if number < 3 && number > 0:
			#number = number - 1
			#tab.current_tab = number
			#print("position",number)
		#elif number == 0:
			#number = 2
			#tab.current_tab = 2
			#print("position",number)


func _on_button_selos_pressed() -> void:
	#Selos.visible = true
	tab.current_tab = 1
func _on_button_missions_pressed() -> void:
	tab.current_tab = 0
	
func _on_button_mapa_pressed() -> void:
	tab.current_tab = 2
	
func _on_button_config_pressed() -> void:
	tab.current_tab = 2
	
func _on_buttoninventario_pressed() -> void:
	tab.current_tab = 2
	
func equip_seal(slot):
	var _itemres = slot
	var _tempItem = slot
	
	SignalManager.inventory.equip_item_at_index(currently_selected)
	
func _unhandled_input(event):
	if %TabContainer.current_tab == 0:
		if Input.is_action_just_pressed("selector_up"):
			%Config.move_selector_U()
		if Input.is_action_just_pressed("selector_down"):
			%Config.move_selector_D()
		if Input.is_action_just_pressed("inventory_less"):
			%Config.show_less_options()
			%Config.goto_options()
		if Input.is_action_just_pressed("inventory_more"):
			%Config.show_more_options()
			%Config.goto_options()
		if Input.is_action_just_pressed("Attack"):
			%Config.selectioned_press()
		if Input.is_action_just_pressed("Jump"):
			%Config.out_options()
	
	#var slot = slots[currently_selected]
	if currently_selected >= 8:
		$TabContainer/Selos/TabContainer.current_tab = 1
		%nextpage_right.visible = false
		%nextpage_left.visible = true
	elif currently_selected <= 8:
		$TabContainer/Selos/TabContainer.current_tab = 0
		%nextpage_right.visible = true
		%nextpage_left.visible = false
	if isOpen && %TabContainer.current_tab == 2:
		if event.is_action_pressed("selector_right"):
			move_selector_R()
		if event.is_action_pressed("selector_left"):
			move_selector_L()
		if event.is_action_pressed("selector_down"):
			move_selector_D()
		if event.is_action_pressed("selector_up"):
			move_selector_U()
		if event.is_action_pressed("Jump"):
			pass
			#onSlotClicked(slot)
		if event.is_action_pressed("Attack"):
			
			SignalManager.equipstamp(slots, sealslots, currently_selected, SignalManager.inventoryc)
			#move_selector_stamp()
			
		
	if isOpen && %TabContainer.current_tab == 3:
		if event.is_action_pressed("selector_right"):
			move_selector_RB()
		if event.is_action_pressed("selector_left"):
			move_selector_LB()
		if event.is_action_pressed("selector_down"):
			move_selector_DB()
		if event.is_action_pressed("selector_up"):
			move_selector_UB()
		





func show_item():
		var islots = slots
		var slot = islots
		
		if !islots[next_selected].itemStackGui == null:
			nextEmpty = false
		else: 
			nextEmpty = true
		if !islots[previously_selected].itemStackGui == null:
			previousEmpty = false
		else: 
			previousEmpty = true
		
		if !islots[currently_selected].itemStackGui == null:
			$TabContainer/Selos/ShowStamppoint.visible = true
			stamppointname_label.set_text(str(slot[currently_selected].itemStackGui.inventorySlot.item.stamp_points))
			print(slot[currently_selected].itemStackGui.inventorySlot.item.stamp_points)
			set_selotype(slot)
			nameLabel.set_text(slot[currently_selected].itemStackGui.inventorySlot.item.showname)
			descLabel.set_text(slot[currently_selected].itemStackGui.inventorySlot.item.description)
			showSprite.texture = slot[currently_selected].itemStackGui.inventorySlot.item.texture

func set_selotype(slot):
	var adesivo = AdesivoManager.new()
	var tipozinho = slot[currently_selected].itemStackGui.inventorySlot.item.item_type
	typelabel.set_text(tipozinho)
	var index = 0
	print(adesivo.tipo[0].tipo)
	for i in adesivo.tipo:
		if i.tipo == tipozinho:
				typelabel.add_theme_color_override("default_color", i.cor)

func show_itemb(invslot):
		invslot = invslots
		if !invslots[next_selectedb].get_parent() == $"TabContainer/Inventário/Specialslots":
			if !invslots[next_selectedb].itemStackGuib == null:
				nextEmpty = false
			else: 
				nextEmpty = true
		if !invslots[previously_selectedb].get_parent() == $"TabContainer/Inventário/Specialslots":
			if !invslots[previously_selectedb].itemStackGuib == null:
				previousEmpty = false
			else: 
				previousEmpty = true
		if !invslots[currently_selectedb].get_parent() == $"TabContainer/Inventário/Specialslots":
			if !invslots[currently_selectedb].itemStackGuib == null:
				nameLabelb.set_text(invslot[currently_selectedb].itemStackGuib.inventorySlotb.item.showname)
				descLabelb.set_text(invslot[currently_selectedb].itemStackGuib.inventorySlotb.item.description)
				showSpriteb.texture = invslot[currently_selectedb].itemStackGuib.inventorySlotb.item.texture
		elif invslots[currently_selectedb].get_parent() == $"TabContainer/Inventário/Specialslots":
			invslots[currently_selectedb].display_item(nameLabelb,descLabelb,showSpriteb)
			
func move_selector_R():
	var islots = slots
	currently_selected = (currently_selected + 1) % islots.size()
	next_selected = (currently_selected + 1) % islots.size()
	previously_selected = (currently_selected - 2) % islots.size()
	selector.global_position = islots[currently_selected].global_position
	selected.emit()
	show_item()

func move_selector_L():
	currently_selected = (currently_selected - 1) % slots.size()
	selector.global_position = slots[currently_selected].global_position
	selected.emit()
	show_item()
func move_selector_U():
	
	currently_selected = (currently_selected - 4) % slots.size()
	selector.global_position = slots[currently_selected].global_position
	selected.emit()
	show_item()
func move_selector_D():
	currently_selected = (currently_selected + 4) % slots.size()
	selector.global_position = slots[currently_selected].global_position
	selected.emit()
	show_item()
func move_selector_stamp():
	currently_selected = 1 % sealslots.size()
	selector.global_position = slots[currently_selected].global_position
	selected.emit()
	show_item()

################################################################################

func move_selector_RB():
	var invslot = invslots
	currently_selectedb = (currently_selectedb + 1) % invslots.size()
	next_selectedb = (currently_selectedb + 1) % invslots.size()
	previously_selectedb = (currently_selectedb - 2) % invslots.size()
	selectorb.global_position = invslots[currently_selectedb].global_position
	selected.emit()
	show_itemb(invslot)

func move_selector_LB():
	var invslot = invslots
	currently_selectedb = (currently_selectedb - 1) % invslots.size()
	next_selectedb = (currently_selectedb + 1) % invslots.size()
	previously_selectedb = (currently_selectedb - 2) % invslots.size()
	selectorb.global_position = invslots[currently_selectedb].global_position
	selected.emit()
	show_itemb(invslot)
func move_selector_UB():
	var invslot = invslots
	currently_selectedb = (currently_selectedb - 5) % invslots.size()
	next_selectedb = (currently_selectedb + 1) % invslots.size()
	previously_selectedb = (currently_selectedb - 2) % invslots.size()
	selectorb.global_position = invslots[currently_selectedb].global_position
	
	selected.emit()
	show_itemb(invslot)
func move_selector_DB():
	var invslot = invslots
	currently_selectedb = (currently_selectedb + 5) % invslots.size()
	next_selectedb = (currently_selectedb + 1) % invslots.size()
	previously_selectedb = (currently_selectedb - 2) % invslots.size()
	selectorb.global_position = invslots[currently_selectedb].global_position
	selected.emit()
	show_itemb(invslot)
	



func _on_stamp_equiped(_slot) -> void:
	print("stamp")


func _on_tab_container_tab_changed(_tab: int) -> void:
	pass


func _on_menu_buttonconfig_pressed() -> void:
	tab.current_tab = 0


func _on_menu_buttontasks_pressed() -> void:
	tab.current_tab = 1


func _on_menu_buttonstamps_pressed() -> void:
	tab.current_tab = 2


func _on_menu_buttonmap_pressed() -> void:
	pass


func _on_menu_buttonitems_pressed() -> void:
	tab.current_tab = 3
