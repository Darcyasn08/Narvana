extends Node3D

@export var player: CharacterBody3D

func _physics_process(_delta: float) -> void:
	if player != null:
		look_at(player.get_node("camera_pivot/SpringArm3D/Camera3D").global_position)
