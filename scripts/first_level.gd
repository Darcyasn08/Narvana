extends Node3D

func _ready() -> void:
	Global.player_can_attack = true
	SignalBus.on_first_level_entered.emit()
	await get_tree().create_timer(3).timeout
	#print($Area3D/CollisionShape3D.disabled)

func _on_timer_timeout() -> void:
	pass
	#$platform2.show()
