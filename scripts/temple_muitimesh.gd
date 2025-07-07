extends MultiMeshInstance3D

var mesh_size: float = 10.5
var n: int

func _ready() -> void:
	n = multimesh.instance_count - 1
	multimesh.visible_instance_count = n + 1
	for i in range(0,n):
		multimesh.set_instance_transform(i, Transform3D(Basis(), Vector3(mesh_size*i,0,0)))
		print(mesh_size)
