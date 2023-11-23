extends Resource
class_name SlotData

# Maximum stack size for items in a slot
const MAX_STACK_SIZE: int = 99

# Item data associated with the slot
@export var item_data: ItemData

# Quantity of the item in the slot (limited by MAX_STACK_SIZE)
@export_range(1, MAX_STACK_SIZE) var quantity: int = 1: set = set_quantity

# Check if two SlotData instances can merge
func can_merge_with(other_slot_data: SlotData) -> bool:
	return item_data == other_slot_data.item_data \
			and item_data.stackable \
			and quantity < MAX_STACK_SIZE

# Check if two SlotData instances can fully merge
func can_fully_merge_with(other_slot_data: SlotData) -> bool:
	return item_data == other_slot_data.item_data \
			and item_data.stackable \
			and quantity + other_slot_data.quantity <= MAX_STACK_SIZE

# Fully merge two SlotData instances
func fully_merge_with(other_slot_data: SlotData) -> void:
	quantity += other_slot_data.quantity

# Create a new SlotData instance with a quantity of 1 and adjust the original quantity
func create_single_slot_data() -> SlotData:
	var new_slot_data = duplicate()
	new_slot_data.quantity = 1
	quantity -= 1
	return new_slot_data

# Set the quantity of the slot, with validation for stackability
func set_quantity(value: int) -> void:
	quantity = value
	if quantity > 1 and not item_data.stackable:
		quantity = 1
		push_error("%s is not stackable, setting quantity to 1" % item_data.name)
