# This script extends the StaticBody2D class.
extends StaticBody2D

# Signal emitted when the player interacts with this object to toggle the inventory.
signal toggle_inventory(external_inventory_owner)

# Exports a variable for the inventory data.
@export var inventory_data: InventoryData

# Function called when the player interacts with this object.
func player_interact() -> void:
	# Emit the toggle_inventory signal, passing 'self' as the external_inventory_owner.
	toggle_inventory.emit(self)
