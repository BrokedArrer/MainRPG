extends Sprite2D

class_name HandEquip



@export var equipped_item : ItemDataWeapon : 
	set(next_equipped):
		equipped_item = next_equipped
		self.texture = equipped_item.texture


func _on_area_2d_body_entered(body):
	if(equipped_item.has_method("interact_with_body")):
		equipped_item.interact_with_body(body)
	
