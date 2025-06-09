extends Node3D

func _on_player_move_area_body_entered(body: Node3D) -> void:
	if body.name == "player":
		$grass/AnimationPlayer.play("grass_moving")
