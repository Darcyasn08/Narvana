extends Node3D

func _ready() -> void:
	$player.position = Global.player_first_level_pos
	Global.player_can_attack = true
	SignalBus.on_first_level_entered.emit()
	Global.current_world = Global.worlds.FIRST_LEVEL
	#print($Area3D/CollisionShape3D.disabled)


func _on_thermal_water_body_entered(body: Node3D) -> void:
	if body.name == "player":
		Global.player_health = Global.max_player_health
		SignalBus.on_player_health_changed.emit(Global.player_health)
		SignalBus.on_thermal_water_used.emit()
