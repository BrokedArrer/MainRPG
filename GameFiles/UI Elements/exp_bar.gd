
extends TextureProgressBar


func _init(current, maximum):
	max_value = maximum
	value = current
	
func _on_player_experience_gained(growth_data):
	for line in growth_data:
		var target_experience = line[0]
		var maximum_experience = line[1]
		var max_value = maximum_experience

func animate_value(target, tween_duration=1.0):
	pass
