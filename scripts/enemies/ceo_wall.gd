extends Area3D


func _on_area_entered(area: Area3D) -> void:
	if area.name == "player_hitbox":
		SignalBus.on_narval_next_to_wall.emit()
