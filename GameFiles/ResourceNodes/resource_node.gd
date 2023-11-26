extends StaticBody2D


class_name ResourceNode
@export var node_types : Array[ResourceNodeType]
@export var starting_resources : int
@export var pickup_type : PackedScene 
@export var depleted_effect : PackedScene
const PickUp = preload("res://GameFiles/Item/pick_up/pick_up_minable.tscn")
@onready var level_parent = get_parent()
@export var launch_speed : float = 100
@export var launch_duration : float = 0.25

var current_resources : int :
	set(resource_count):
		current_resources = resource_count
		#A Resource node emptied of its resources is removed from the scene.
		if(resource_count <= 0):
			#spawn particle effect before removing node
			var effect_instance : GPUParticles2D = depleted_effect.instantiate()
			effect_instance.position = position
			level_parent.add_child(effect_instance)
			effect_instance.emitting = true
			queue_free()
			
			
func _ready():
	current_resources = starting_resources
	

			


func harvest(amount: int):
	for i in range(amount):  # Use range to loop the specified number of times
		spawn_resource()

	current_resources -= amount
	
	
func spawn_resource():
	call_deferred("_spawn_resource")	
	
func _spawn_resource():
	var pick_up = PickUp.instantiate()
	level_parent.add_child(pick_up)
	pick_up.position = position
	
	var direction : Vector2 = Vector2(
		randf_range(-1.0, 1.0),
		randf_range(-1.0, 1.0)
	).normalized()

	pick_up.launch(direction * launch_speed, launch_duration)
