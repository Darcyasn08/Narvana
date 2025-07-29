extends Node3D

func _ready() -> void:
	#Global.dead_enemies_first_level.clear()
	Global.player_can_attack = true
	SignalBus.on_first_level_entered.emit()
	Global.current_world = Global.worlds.FIRST_LEVEL
	#print($Area3D/CollisionShape3D.disabled)
