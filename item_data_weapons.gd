extends ItemData
class_name ItemDataWeapon


@export var effected_types : Array[Enemy]
@export var minDamage: int;
@export var maxDamage: int;
@export var Value: int;
@export var Rarity: String;

func interact_with_body(body):
	if(body is Enemy): 
		print_debug("Match found at " + body.name)
		body.take_damage(randi_range(minDamage, maxDamage))
		
		
