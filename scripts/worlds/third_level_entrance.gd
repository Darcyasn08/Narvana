extends Node3D

func _ready() -> void:
	Global.current_world = Global.worlds.THIRD_LEVEL
	$player.global_position = Global.player_third_level_pos
