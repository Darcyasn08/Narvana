extends Node3D

func _ready() -> void:
	$AnimationPlayer.speed_scale = randi_range(.4,1.1)
	$AnimationPlayer.play("drop")
	rotation.y = deg_to_rad(randi_range(0,360))
	print(rotation.y)
