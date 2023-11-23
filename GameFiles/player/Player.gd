extends CharacterBody2D

# Define a signal to toggle the inventory
signal toggle_inventory()
signal inventory_interact(inventory_data: InventoryData, index: int, button:int)

# Reference to the 2D camera and raycast nodes for interaction in different directions
@onready var camera_2d: Camera2D = $Camera2D
@onready var interact_ray: RayCast2D = $Camera2D/InteractRay
@onready var interact_ray_up: RayCast2D = $Camera2D/InteractRayUp
@onready var interact_ray_right: RayCast2D = $Camera2D/InteractRayRight
@onready var interact_ray_left: RayCast2D = $Camera2D/InteractRayLeft

#Reference to the Animation Tree.
@onready var animation_tree : AnimationTree = $AnimationTree

# Player's health and exported variables for inventory data and movement speed
@export var hotbar_inventory_data: InventoryDataHotbar
@export var equip_inventory_data: InventoryDataEquip
@export var inventory_data: InventoryData
@export var speed : float = 100.0
signal healthChanged

@export var maxHealth := 25
@onready var current_health: int = maxHealth
var player_isalive = true
# Variables to track player direction and movement
var direction : Vector2 = Vector2.ZERO
#test variables for combat
var enemy_inattack_range = false
var enemy_attack_cooldown = true


# Initialization function
func _ready() -> void:
	PlayerManager.player = self
	animation_tree.active = true
#Update animation directions.
func _process(_delta):
	update_animation_parameters()
	
	
func update_health():
	var healthbar = $TextureProgressBar
	healthbar.value = current_health
	
	
func update_animation_parameters():
	if(velocity == Vector2.ZERO):
		animation_tree["parameters/conditions/idle"] = true
		animation_tree["parameters/conditions/is_moving"] = false
	else:
		animation_tree["parameters/conditions/idle"] = false
		animation_tree["parameters/conditions/is_moving"] = true

	if(Input.is_action_just_pressed("use")):
		animation_tree["parameters/conditions/swing"] = true
	else:
		animation_tree["parameters/conditions/swing"] = false
		
	if(direction != Vector2.ZERO):
		animation_tree["parameters/idle/blend_position"] = direction
		animation_tree["parameters/swing/blend_position"] = direction
		animation_tree["parameters/walk/blend_position"] = direction

# Function to handle unhandled input events
func _unhandled_input(_event: InputEvent) -> void:
	# Toggle the inventory when the "Inventory" action is just pressed
	if Input.is_action_just_pressed("Inventory"):
		toggle_inventory.emit()

	# Perform interaction when the "Interact" action is just pressed
	if Input.is_action_just_pressed("Interact"):
		interact()
		

# Function called every physics frame to handle player movement
func _physics_process(_delta):
	# Get input vector and normalize it to handle movement in 4 directions
	direction = Input.get_vector("left", "right", "up", "down").normalized()
	
	# Set velocity based on the input direction and speed
	if direction:
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO
	
	# Move and slide the player
	move_and_slide()
	enemy_attack()
	update_health()
	#This is where we could "die" and add death functions.
	#if maxHealth <= 0:
		#player_isalive = false
		#health = 0
		#print("player has died.")
		#pass

# Function to handle player interaction
func interact() -> void:
	# Check which ray is colliding and trigger interaction with the colliding object
	if interact_ray.is_colliding():
		interact_ray.get_collider().player_interact()
	elif interact_ray_up.is_colliding():
		interact_ray_up.get_collider().player_interact()
	elif interact_ray_right.is_colliding():
		interact_ray_right.get_collider().player_interact()
	elif interact_ray_left.is_colliding():
		interact_ray_left.get_collider().player_interact()


func player():
	pass


func _on_player_hit_box_body_entered(body):
	if body.has_method("enemy"):
		enemy_inattack_range = true
		


func _on_player_hit_box_body_exited(body):
	if body.has_method("enemy"):
		enemy_inattack_range = false

func enemy_attack():
	if enemy_inattack_range and enemy_attack_cooldown == true:
		current_health = current_health - 1
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		update_health()
		print(current_health)


func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true
