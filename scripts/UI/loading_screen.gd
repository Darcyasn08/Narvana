extends CanvasLayer

func _ready() -> void:
	if SaveLoad.save_content.has_started_game:
		var current_world = SaveLoad.save_content.current_world
		match current_world:
			0:
				var game_inst: Object = preload("res://scripts/normal_world.gd")
				var game = game_inst.instantiate()
				add_child(game)
	else:
		print("open_ normal world")
		get_tree().change_scene_to_file("res://scenes/worlds/normal_world.tscn")
