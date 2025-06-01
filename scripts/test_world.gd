extends Node3D

func _physics_process(delta: float) -> void:
	pass
	#if $DirectionalLight3D.rotation.x > -179 and $DirectionalLight3D.rotation.x < 1:
		#$DirectionalLight3D.rotation.x += deg_to_rad(.08)
	#else:
		#$DirectionalLight3D.rotation.x += deg_to_rad(5)
