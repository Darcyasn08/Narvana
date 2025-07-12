extends Node3D

@export var npc_model: Node
var parent_color: int

func _ready() -> void:
	var original_resource: Object = load("res://shaders/jellyfish_npc_body.tres")
	var unique_resource: Object = original_resource.duplicate()
	$"../jellyfish-npc/body".material_override = unique_resource
	
	#define uma cor pra cada npc
	if npc_model != null:
		parent_color = get_parent().current_color
		match parent_color:
			0:
				npc_model.material_override.albedo_color = Color(.8,0,0)
				#print(npc_model.get_material_override().albedo_color)
			1:
				npc_model.get_material_override().albedo_color = Color(0,.9,.1)
				#print(npc_model.get_material_override().albedo_color)
			2:
				npc_model.get_material_override().albedo_color = Color(0,.2,.6)
				#print(npc_model.get_material_override().albedo_color)
