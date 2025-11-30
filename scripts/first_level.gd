extends Node3D

var used_cure: bool = false

func _ready() -> void:
	Global.current_world = Global.worlds.FIRST_LEVEL
	$player.position = Global.player_first_level_pos
	Global.player_can_attack = true
	SignalBus.on_first_level_entered.emit()


func _on_thermal_water_body_entered(body: Node3D) -> void:
	if body.name == "player" and !used_cure:
		Global.player_health = Global.max_player_health
		SignalBus.on_player_health_changed.emit(Global.player_health)
		SignalBus.on_thermal_water_used.emit()
		used_cure = true
