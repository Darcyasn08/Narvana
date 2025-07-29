extends MultiMeshInstance3D

func _ready() -> void:
	multimesh.set_instance_transform(0, Transform3D(Basis(), Vector3(0,0,0)))
	multimesh.set_instance_transform(1, Transform3D(Basis(), Vector3(-20,0,0)))
	multimesh.set_instance_transform(2, Transform3D(Basis(), Vector3(-20,0,-18)))
	multimesh.set_instance_transform(3, Transform3D(Basis(), Vector3(0,0,-18)))
	$MeshInstance3D.hide()
