# This script extends the RigidBody2D class.
extends RigidBody2D

# Exported variable for storing slot data.
@export var slot_data: SlotData

# OnReady variable for referencing the Sprite2D node.
@onready var sprite_2d: Sprite2D = $Sprite2D
var launch_velocity : Vector2 = Vector2.ZERO

var move_duration : float = 0
var time_since_launch : float = 0
var launching : bool = false :
	set(is_launching):
		launching = is_launching
		
		set_deferred("collision_shape.disabled", launching)
		

# Function called when the node and its children are added to the scene.
func _ready() -> void:
	# Set the texture of the Sprite2D node to the texture of the item associated with the slot data.
	sprite_2d.texture = slot_data.item_data.texture
	
	
func _process(delta):
	# Move the pickup only after a launch, not every pickup spawns in this way
	# but all have the ability to
	if(launching):
		position += launch_velocity * delta
		time_since_launch += delta
		
		if(time_since_launch >= move_duration):
			launching = false
			
			
func launch(velocity : Vector2, duration : float):
	launch_velocity = velocity
	move_duration = duration
	time_since_launch = 0
	launching = true

# Function called when another area's body enters the collision area of this node.
func _on_area_2d_body_entered(body):
	# Check if the body has a method 'pick_up_slot_data' in its inventory_data.
	if body.inventory_data.pick_up_slot_data(slot_data):
		# If successful, free the node (remove it from the scene).
		queue_free()
