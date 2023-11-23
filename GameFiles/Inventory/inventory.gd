extends PanelContainer

# Preload the Slot scene for efficient instantiation
const Slot = preload("res://GameFiles/Inventory/slot.tscn")

# Reference to the GridContainer where slots will be added
@onready var item_grid: GridContainer = $MarginContainer/ItemGrid

# Function to set inventory data and connect it to the grid population
func set_inventory_data(inventory_data: InventoryData) -> void:
	# Connect the inventory_updated signal to the populate_item_grid function
	inventory_data.inventory_updated.connect(populate_item_grid)
	# Populate the item grid with the initial inventory data
	populate_item_grid(inventory_data)

# Function to clear inventory data and disconnect it from the grid population
func clear_inventory_data(inventory_data: InventoryData) -> void:
	# Disconnect the inventory_updated signal from the populate_item_grid function
	inventory_data.inventory_updated.disconnect(populate_item_grid)

# Function to populate the item grid with slot data
func populate_item_grid(inventory_data: InventoryData) -> void:
	# Clear existing child nodes in the item grid
	for child in item_grid.get_children():
		child.queue_free()
	
	# Iterate through slot data in the inventory and instantiate slots
	for slot_data in inventory_data.slot_datas:
		var slot = Slot.instantiate()
		item_grid.add_child(slot)
		
		# Connect the slot_clicked signal to the on_slot_clicked function in the inventory data
		slot.slot_clicked.connect(inventory_data.on_slot_clicked)
		
		# Set slot data if available (non-null)
		if slot_data:
			slot.set_slot_data(slot_data)

