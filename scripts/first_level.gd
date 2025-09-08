extends Node3D

func _ready() -> void:
	$player.position = Global.player_first_level_pos
	Global.player_can_attack = true
	SignalBus.on_first_level_entered.emit()
	Global.current_world = Global.worlds.FIRST_LEVEL
	#print($Area3D/CollisionShape3D.disabled)
