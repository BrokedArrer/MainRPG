extends CharacterBody2D

class_name Enemy
@export var maxHealth: int
var speed : float = 60.0
var player_chase = false
var player = null
@onready var current_health: int = maxHealth
var enemy_isalive = true
signal healthChanged


func _physics_process(_delta):
	update_health()
	if player_chase:
		position += (player.position - position)/speed
		

func _on_detection_area_body_entered(body):
	player = body
	player_chase = true
	

func _on_detection_area_body_exited(_body):
	player = null
	player_chase = false


func enemy():
	pass

func take_damage(damage: int):
	current_health -= damage
	current_health = current_health
	print(current_health)
	if current_health <= 0:
		enemy_isalive = false
		# You can add any death logic here, like playing an animation or spawning items.
		queue_free()
		player.gain_experience(500)
		
func update_health():
	var healthbar = $TextureProgressBar
	healthbar.value = current_health
