extends CharacterBody2D

# Define a signal to toggle the inventory
signal toggle_inventory()
signal inventory_interact(inventory_data: InventoryData, index: int, button:int)

# Reference to the 2D camera and raycast nodes for interaction in different directions
@onready var camera_2d: Camera2D = $Camera2D

# Variables to track player direction and movement
var direction : Vector2 = Vector2.ZERO

#Reference to the Animation Tree.
@onready var animation_tree : AnimationTree = $AnimationTree

#Exported variables for inventory data
@export var hotbar_inventory_data: InventoryDataHotbar
@export var equip_inventory_data: InventoryDataEquip
@export var inventory_data: InventoryData
@export var speed : float = 100.0
#Players Health Cahnges
signal healthChanged

@onready var current_health: int = maxHealth
var player_isalive = true

#Players Experience
@export var level: int = 1
var experience: int
var experience_total: int
var experience_required = get_required_experience(level + 1)
signal experience_gained

#Player Stats
@export var maxHealth := 25
@export var strength: int = 1
@export var vitality: int = 1


#test variables for combat
var enemy_inattack_range = false
var enemy_attack_cooldown = true


# Initialization function
func _ready() -> void:
	PlayerManager.player = self
	animation_tree.active = true
	$"../../Ui/ExpLabel".update_text(level, experience, experience_required)
#Update animation directions.
func _process(_delta):
	update_animation_parameters()
	
	
func update_health():
	var healthbar = $"../../Ui/TextureProgressBar"
	healthbar.value = current_health
func update_experience():
	var experiencebar = $"../../Ui/ExpBar"
	experiencebar.value = experience

func get_required_experience(level):
	return pow(level, 7) + level * 4

func gain_experience(amount):
	experience_total += amount
	experience += amount
	while experience >= experience_required:
		experience -= experience_required
		level_up()
	$"../../Ui/ExpLabel".update_text(level, experience, experience_required)
	update_experience()
	
	
func level_up():
	level += 1
	experience_required = get_required_experience(level + 1)
	var stats = ['maxHealth']
	#var stats = ['maxHealth', 'strength', 'vitality'] // This is how to add more stats
	var random_stat = stats[randi() % stats.size()]
	set(random_stat, get(random_stat) + randi() % 4 + 2)
	
	
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
	
	if Input.is_action_just_pressed("hotbar_slot_1"):
		print("Button 1 Pressed")


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
	var overlapping_bodies = $InteractionArea.get_overlapping_bodies()
	# Check which ray is colliding and trigger interaction with the colliding object
	for body in overlapping_bodies:
		if body.has_method("player_interact"):
			body.player_interact()
			return


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
		#current_health = current_health - 1
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		update_health()
		print(current_health)


func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true

