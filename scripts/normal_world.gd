extends Node3D

func _ready() -> void:
	$player.position = Global.player_normal_pos
	#Global.player_can_attack = false
	Global.current_world = Global.worlds.NORMAL
