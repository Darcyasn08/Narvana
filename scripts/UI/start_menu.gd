extends CanvasLayer

func _on_start_button_pressed() -> void:
	$save_screen.show()


func _on_start_save_pressed() -> void:
	await SaveLoad.load_save()
	if SaveLoad.save_content.has_started_game:
		print("a game has started")
	else:
		get_tree().change_scene_to_file("res://scenes/UI/loading_screen.tscn")
