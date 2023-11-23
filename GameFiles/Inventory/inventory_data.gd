extends Resource
class_name InventoryData

# Signal emitted when the inventory is updated
signal inventory_updated(inventory_data: InventoryData)

# Signal emitted when an interaction with the inventory occurs
signal inventory_interact(inventory_data: InventoryData, index: int, button:int)

# Array to store SlotData objects representing inventory slots
@export var slot_datas: Array[SlotData]



# Grab a SlotData from a specific index in the inventory
func grab_slot_data(index: int) -> SlotData:
	var slot_data = slot_datas[index]

	if slot_data:
		# Clear the slot if it contains data and emit the inventory update signal
		slot_datas[index] = null
		inventory_updated.emit(self)
		return slot_data
	else:
		return null

# Drop a SlotData into a specific index in the inventory
func drop_slot_data(grabbed_slot_data: SlotData, index: int) -> SlotData:
	var slot_data = slot_datas[index]

	var return_slot_data: SlotData
	if slot_data and slot_data.can_fully_merge_with(grabbed_slot_data):
		# If the slot can fully merge with the grabbed slot, merge them
		slot_data.fully_merge_with(grabbed_slot_data)
	else:
		# Otherwise, replace the slot with the grabbed slot
		slot_datas[index] = grabbed_slot_data
		return_slot_data = slot_data

	# Emit the inventory update signal
	inventory_updated.emit(self)
	return return_slot_data

# Drop a single unit of SlotData into a specific index in the inventory
func drop_single_slot_data(grabbed_slot_data: SlotData, index: int) -> SlotData:
	var slot_data = slot_datas[index]

	if not slot_data:
		# If the slot is empty, create a new slot with a single unit of grabbed data
		slot_datas[index] = grabbed_slot_data.create_single_slot_data()
	elif slot_data.can_merge_with(grabbed_slot_data):
		# If the slot can merge with the grabbed slot, merge them
		slot_data.fully_merge_with(grabbed_slot_data.create_single_slot_data())

	# Emit the inventory update signal
	inventory_updated.emit(self)

	if grabbed_slot_data.quantity > 0:
		return grabbed_slot_data
	else:
		return null

# Use the data in a specific inventory slot
func use_slot_data(index: int) -> void:
	var slot_data = slot_datas[index]

	if not slot_data:
		return

	if slot_data.item_data is ItemDataConsumable:
		print(slot_data.item_data.name)
		# If the item is consumable, decrease its quantity and remove it if necessary
		slot_data.quantity -= 1
		if slot_data.quantity < 1:
			slot_datas[index] = null
			
	
	
		
		
		
	# Call the use_slot_data function on the PlayerManager with the slot data
	PlayerManager.use_slot_data(slot_data)

	# Emit the inventory update signal
	inventory_updated.emit(self)


		
		
# Attempt to pick up a SlotData by merging or placing it in an empty slot
func pick_up_slot_data(slot_data: SlotData) -> bool:
	for index in slot_datas.size():
		if slot_datas[index] and slot_datas[index].can_fully_merge_with(slot_data):
			# If a slot can fully merge with the grabbed slot, merge them
			slot_datas[index].fully_merge_with(slot_data)
			inventory_updated.emit(self)
			return true

	for index in slot_datas.size():
		if not slot_datas[index]:
			# If an empty slot is found, place the grabbed slot in it
			slot_datas[index] = slot_data
			inventory_updated.emit(self)
			return true

	return false

# Signal handler for when a slot is clicked
func on_slot_clicked(index: int, button:int):
	# Emit the inventory interaction signal with the clicked slot's index and button
	inventory_interact.emit(self, index, button)


