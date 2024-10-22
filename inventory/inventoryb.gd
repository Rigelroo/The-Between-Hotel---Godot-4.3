extends Resource

class_name Inventoryb

signal updated
#signal equip_item

@export var invslots: Array[InventorySlotb]

func insert(item: InventoryItemb):
	for invslot in invslots:
		if invslot.item == item:
			if invslot.amount >= item.maxAmountInStack:
				continue
			invslot.amount += 1
			updated.emit()
			return
	for j in range(invslots.size()):
		if !invslots[j].item:
			invslots[j].item = item
			invslots[j].amount = 1
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
	for invslot in invslots:
		if invslot.item == item:
			invslot.amount += 1
			updated.emit()
			return
	
	for j in range(invslots.size()):
		if !invslots[j].item:
			invslots[j].item = item
			invslots[j].amount = 1
			updated.emit()
			return
	
func removeSlot(inventorySlotb: InventorySlotb):
	var index = invslots.find(inventorySlotb)
	if index < 0: return
	remove_at_index(index)
	invslots[index] = InventorySlotb.new()
	updated.emit()

func remove_at_index(index: int) -> void:
	invslots[index] = InventorySlotb.new()
	print("oi")
	
	updated.emit()
	
	
func insertSlot(index: int, inventorySlotb: InventorySlotb):
	
	invslots[index] = inventorySlotb
	updated.emit()

##func equip_item_at_index(index: int) -> void:
	##if index < 0 || index >= slots.size() || !slots[index].item: return
	##var slot = slots[index]
	##
	##equip_item.emit(invslot.item)
	#
	#if slot.amount > 1:
		#slot.amount - 1
		#updated.emit()
		#return
	#remove_at_index(index)
	#
