extends Node3D

func _ready() -> void:
	$AnimationPlayer.speed_scale = randf_range(.4,1.1)
	$AnimationPlayer.play("drop")
	rotation.y = deg_to_rad(randi_range(0,360))
	print(rotation.y)
	await get_tree().create_timer(1).timeout
	queue_free()
