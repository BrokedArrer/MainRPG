extends Node

# Load the PickUp scene as a constant
const PickUp = preload("res://GameFiles/Item/pick_up/pick_up.tscn")

# Declare variables for player, inventory interface, and hot bar inventory
@onready var player: CharacterBody2D = $Node2D/Player
@onready var inventory_interface: Control = $Ui/InventoryInterface
@onready var hot_bar_inventory: PanelContainer = $Ui/HotBarInventory

# Called when the script instance is created
func _ready() -> void:
	# Connect signals to respective functions
	player.toggle_inventory.connect(toggle_inventory_interface)
	inventory_interface.set_player_inventory_data(player.inventory_data)
	inventory_interface.set_equip_inventory_data(player.equip_inventory_data)
	inventory_interface.set_hotbar_inventory_data(player.hotbar_inventory_data)
	inventory_interface.force_close.connect(toggle_inventory_interface)
	hot_bar_inventory.set_inventory_data(player.inventory_data)
	
	# Connect external inventory signals
	for node in get_tree().get_nodes_in_group("external_inventory"):
		node.toggle_inventory.connect(toggle_inventory_interface)

# Toggle the visibility of the inventory interface
func toggle_inventory_interface(external_inventory_owner = null) -> void:
	inventory_interface.visible = not inventory_interface.visible
	
	# Set mouse mode based on inventory visibility
	if inventory_interface.visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
	# If an external inventory is provided and the interface is visible, set its data
	if external_inventory_owner and inventory_interface.visible:
		inventory_interface.set_external_inventory(external_inventory_owner)
	else:
		inventory_interface.clear_external_inventory()

# Called when data is dropped onto the inventory interface
func _on_inventory_interface_drop_slot_data(slot_data):
	# Instantiate a PickUp scene and set its slot data
	var pick_up = PickUp.instantiate()
	pick_up.slot_data = slot_data
	
	# Define the radius around the player for item drop
	var drop_radius = 40.0  # Adjust the radius as needed
	
	# Generate a random angle within a full circle (0 to 2*pi)
	var random_angle = randf() * 2.0 * PI

	# Calculate the drop position within the specified radius
	var drop_position = $Node2D/Player.position + Vector2(cos(random_angle), sin(random_angle)) * drop_radius
	pick_up.position = drop_position
	
	# Add the PickUp instance as a child of the current node
	add_child(pick_up)
