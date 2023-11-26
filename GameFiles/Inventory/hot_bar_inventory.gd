# This script represents a hot bar panel in a game inventory system.

extends PanelContainer

# Signal declaration for notifying when a hot bar slot is used.
#signal hot_bar_use(index: int)

# Preload the Slot scene for instantiation.
const Slot = preload("res://GameFiles/Inventory/slot.tscn")

# Reference to the HBoxContainer child for organizing slots horizontally.
@onready var h_box_container: HBoxContainer = $MarginContainer/HBoxContainer

# Handle unhandled key inputs, specifically numeric keys 1 to 7.
#func _unhandled_key_input(event: InputEvent) -> void:
	# Ignore input if the panel is not visible or the key is not pressed.
	#if not visible or not event.is_pressed():
	#	return
	
	# Emit the hot_bar_use signal with the corresponding index when a numeric key is pressed.
	#if range(KEY_1, KEY_7).has(event.keycode):
	#	hot_bar_use.emit(event.keycode - KEY_1)

# Set the inventory data and connect signals.
func set_inventory_data(inventory_data: InventoryData) -> void:
	# Connect the inventory_updated signal to the populate_hot_bar method.
	inventory_data.inventory_updated.connect(populate_hot_bar)
	# Initial population of the hot bar based on the provided inventory_data.
	populate_hot_bar(inventory_data)
	# Connect the hot_bar_use signal to the use_slot_data method of inventory_data.
	#hot_bar_use.connect(inventory_data.use_slot_data)

# Populate the hot bar with slots based on the provided inventory data.
func populate_hot_bar(inventory_data: InventoryData) -> void:
	# Clear existing slots in the hot bar.
	for child in h_box_container.get_children():
		child.queue_free()
	
	# Iterate over the first six elements of slot data and instantiate slots in the hot bar.
	for slot_data in inventory_data.slot_datas.slice(0, 6):
		var slot = Slot.instantiate()
		h_box_container.add_child(slot)
		
		slot.slot_clicked.connect(inventory_data.on_slot_clicked)
		
		# If slot_data is not null, set the slot data.
		if slot_data:
			slot.set_slot_data(slot_data)
