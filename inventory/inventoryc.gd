extends Resource

class_name Inventoryc

signal updated
#signal stamp_equipped
#signal stamp_unequipped

@export var stampslots: Array[InventorySlotc]

func call_update():
	updated.emit()

func insert(item: InventoryItem):
	
	for stampslot in stampslots:
		if stampslot.item == item:
			stampslot.item = null
			#stampslot.item.max_amount = 2
			#if stampslot.amount >= stampslot.item.max_amount:
				#continue
			#stampslot.amount += 1
			updated.emit()
			SignalManager.stamp_unequipped.emit()
			
			return
		if stampslot.item == item:
			stampslot.item = null
			#if stampslot.amount >= stampslot.item.maxAmountInStack:
				#continue
			#stampslot.amount += 1
			updated.emit()
			return

	for i in range(stampslots.size()):
		if !stampslots[i].item:
			stampslots[i].item = item
			stampslots[i].amount = 1
			updated.emit()
			SignalManager.stamp_equipped.emit()
			return


	#for stampslot in stampslots:
		#if stampslot.item == item:
			#stampslot.item = null
			##stampslot.amount += 1
			##updated.emit()
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
	
	
	
func removeSlot(inventorySlot: InventorySlotc):
	var index = stampslots.find(inventorySlot)
	if index < 0: return
	
	stampslots[index] = InventorySlotc.new()
	updated.emit()
	
func insertSlot(index: int, inventorySlot: InventorySlotc):
	stampslots[index] = inventorySlot
	updated.emit()
