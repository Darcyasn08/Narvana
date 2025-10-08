extends Node3D

var coral_mesh_inst: Object = preload("res://scenes/objects/alone_floor_coral.tscn")
@export var coral_count_x: int = 20
@export var coral_count_y: int = 16
var colors: Array = [Color(0.689, 0.244, 0.66, 1.0), Color(0.519, 0.276, 0.759, 1.0), Color(0.394, 0.474, 0.765, 1.0), Color(0.99, 0.852, 0.468, 1.0), Color(0.557, 0.861, 0.711, 1.0), Color(0.934, 0.489, 0.511, 1.0)]
var material: StandardMaterial3D = StandardMaterial3D.new()

func _ready() -> void:
	for x: int in coral_count_x:
		for y: int in coral_count_y:
			if x == 1 or x == coral_count_x:
				pass
			var coral_mesh: Object = coral_mesh_inst.instantiate()
			coral_mesh.position = Vector3(x-randf_range(-.3,.3),randf_range(-.8,-.4),y-randf_range(-.3,.3))
			material.albedo_color = colors[randi_range(0,colors.size()-1)]
			coral_mesh.get_node("alone-coral/Cube").material_override = material.duplicate()
			coral_mesh.rotation_degrees = Vector3(randf_range(-5,5),randf_range(0,360),randf_range(-5,5))
			add_child(coral_mesh)
