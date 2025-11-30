extends Node3D

func _ready() -> void:
	Global.current_world = Global.worlds.THIRD_LEVEL
	$player.global_position = Global.player_third_level_pos


func _on_back_village_area_body_entered(body: Node3D) -> void:
	if body.name == "player":
		Global.next_scene = "res://scenes/worlds/normal_world.tscn"
		get_tree().change_scene_to_file("res://scenes/UI/loading_screen.tscn")
