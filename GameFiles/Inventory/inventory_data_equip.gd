# This script extends the InventoryData class and defines a new class named InventoryDataEquip.
extends InventoryData
class_name InventoryDataEquip

# Function to handle dropping slot data when an item is grabbed and moved to a new slot.
func drop_slot_data(grabbed_slot_data: SlotData, index: int) -> SlotData:
	# Check if the item data associated with the grabbed slot is an instance of ItemDataEquip.
	if not grabbed_slot_data.item_data is ItemDataEquip:
		# If not, return the original grabbed_slot_data without making any changes.
		return grabbed_slot_data

	# If the item data is of type ItemDataEquip, call the drop_slot_data function of the superclass.
	return super.drop_slot_data(grabbed_slot_data, index)

# Function to handle dropping a single slot of data when an item is grabbed and moved.
func drop_single_slot_data(grabbed_slot_data: SlotData, index: int) -> SlotData:
	# Check if the item data associated with the grabbed slot is an instance of ItemDataEquip.
	if not grabbed_slot_data.item_data is ItemDataEquip:
		# If not, return the original grabbed_slot_data without making any changes.
		return grabbed_slot_data

	# If the item data is of type ItemDataEquip, call the drop_single_slot_data function of the superclass.
	return super.drop_single_slot_data(grabbed_slot_data, index)
