extends RayCast3D

@onready var beam = $beam

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	var cast_point
	force_raycast_update()
	
	if is_colliding():
		cast_point = to_local(get_collision_point())
		beam.mesh.height = -cast_point.y
		beam.position.y = cast_point.y/2
