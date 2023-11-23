extends ItemData
class_name ItemDataTool


@export var effected_types : Array[ResourceNodeType]
@export var min_HarvestAmount: int = 1
@export var max_HarvestAmount: int = 2

#If the body interacted is a resource node that matches the effected types
#set for this tool, then the resource node will be harvested between the min and max
#harvesting amounts of the tool.

func interact_with_body(body):
	if(body is ResourceNode):
		for type in effected_types:
			if(body.node_types.has(type)):
				print_debug("Match found at " + type.display_name + " on " + body.name)
				body.harvest(randi_range(min_HarvestAmount, max_HarvestAmount))
