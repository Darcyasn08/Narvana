extends Node3D

func _ready() -> void:
	Global.player_can_attack = false
	Global.current_world = Global.worlds.NORMAL
