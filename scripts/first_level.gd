extends Node3D

func _ready() -> void:
	Global.player_can_attack = true
	SignalBus.on_first_level_entered.emit()
	await get_tree().create_timer(3).timeout
	#print($Area3D/CollisionShape3D.disabled)
	$temple_room1/multi_pillar.multimesh.set_instance_transform(0, Transform3D(Basis(), Vector3(0,0,0)))
	$temple_room1/multi_pillar.multimesh.set_instance_transform(1, Transform3D(Basis(), Vector3(-20,0,0)))
	$temple_room1/multi_pillar.multimesh.set_instance_transform(2, Transform3D(Basis(), Vector3(-20,0,-18)))
	$temple_room1/multi_pillar.multimesh.set_instance_transform(3, Transform3D(Basis(), Vector3(0,0,-18)))
