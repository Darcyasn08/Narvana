extends MultiMeshInstance3D

var temple_pillar_mesh_inst: Object = preload("res://scenes/objects/temple_pillar_mesh.tscn")
var pos: Array = [Vector3(0,0,0), Vector3(-20,0,0), Vector3(-20,0,-18), Vector3(0,0,-18)]

func _ready() -> void:
	#multimesh.set_instance_transform(0, Transform3D(Basis(), Vector3(0,0,0)))
	#multimesh.set_instance_transform(1, Transform3D(Basis(), Vector3(-20,0,0)))
	#multimesh.set_instance_transform(2, Transform3D(Basis(), Vector3(-20,0,-18)))
	#multimesh.set_instance_transform(3, Transform3D(Basis(), Vector3(0,0,-18)))
	for i in range(0,4):
		var temple_pillar_mesh: Object = temple_pillar_mesh_inst.instantiate()
		temple_pillar_mesh.position = pos[i]
		#print(pos[i])
		#print(i)
		add_child(temple_pillar_mesh)
	$MeshInstance3D.hide()
	$MeshInstance3D2.hide()
	$MeshInstance3D3.hide()
	$MeshInstance3D4.hide()
