extends Node3D

func _ready() -> void:
	Global.player_can_attack = true
	SignalBus.on_first_level_entered.emit()
	await get_tree().create_timer(3).timeout
	$Area3D/CollisionShape3D.disabled = false
	#print($Area3D/CollisionShape3D.disabled)

func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.name == "player_hitbox":
		print("aaaaaaaaa")

func _on_timer_timeout() -> void:
	pass
	#$platform2.show()
