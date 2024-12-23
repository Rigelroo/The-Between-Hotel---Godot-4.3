extends Resource

class_name Inventory

signal updated
signal equip_item

@export var slots: Array[InventorySlot]
#@export var sealslots: Array[InventorySlot]




func insert(item: InventoryItem):
	for slot in slots:
		if slot.item == item:
			if slot.amount >= item.maxAmountInStack:
				continue
			slot.amount += 1
			updated.emit()
			return
	for i in range(slots.size()):
		if !slots[i].item:
			slots[i].item = item
			slots[i].amount = 1
			updated.emit()
			return
	#for slot in slots:
		#if slot.item == item:
			#slot.item.max_amount = 2
			#if slot.amount >= slot.item.max_amount:
				#continue
			#slot.amount += 1
			#updated.emit()
			#return
		#if slot.item == item:
			#if slot.amount >= slot.item.maxAmountInStack:
				#continue
			#slot.amount += 1
			#updated.emit()
			#return
	#for slot in slots:
		#if slot.item == item:
			#if slot.amount >= item.maxAmountInStack:
				#continue
			#slot.amount += 1
			#updated.emit()
			#return
	#for i in range(slots.size()):
		#if !slots[i].item:
			#slots[i].item = item
			#slots[i].amount = 1
			#updated.emit()
			#return
	#var itemSlots = slots.filter(func(slot): return slot.item == item && slot.amount < slot.item.maxAmountInStack)
	#if !itemSlots.is_empty():
		#itemSlots[0].amount += 1
	#else:
		#var emptySlots = slots.filter(func(slot): return slot.item == null)
		#if !emptySlots.is_empty():
			#emptySlots[0].item = item
			#emptySlots[0].amount = 1
	#updated.emit()
	for slot in slots:
		if slot.item == item:
			slot.amount += 1
			updated.emit()
			return
	
	for i in range(slots.size()):
		if !slots[i].item:
			slots[i].item = item
			slots[i].amount = 1
			updated.emit()
			
			return
			
	
func removeSlot(inventorySlot: InventorySlot):
	var index = slots.find(inventorySlot)
	if index < 0: return
	remove_at_index(index)
	slots[index] = InventorySlot.new()
	updated.emit()

func remove_at_index(index: int) -> void:
	slots[index] = InventorySlot.new()
	print("oi")
	
	updated.emit()
	
func modulateslot():
	for slot in slots:
		slot.amount = 0
		
func desmodulateslot():
	for slot in slots:
		slot.amount = 1
func insertSlot(index: int, inventorySlot: InventorySlot):
	
	slots[index] = inventorySlot
	updated.emit()

func equip_item_at_index(index: int) -> void:
	if index < 0 || index >= slots.size() || !slots[index].item: return
	var slot = slots[index]
	var _inventoryc = Inventoryc

	equip_item.emit(slot.item)
	
	if slot.amount > 1:
		slot.amount = 0
		
		updated.emit()
		return
	remove_at_index(index)
	
