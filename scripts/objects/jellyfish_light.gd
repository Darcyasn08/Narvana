extends Node3D

func _ready() -> void:
	await get_tree().create_timer(randf_range(0,1.2)).timeout
	$AnimationPlayer.play("light_move")
	$AnimationPlayer.speed_scale = randf_range(.5,.9)
