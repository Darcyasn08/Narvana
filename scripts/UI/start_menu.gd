extends CanvasLayer

func _on_start_button_pressed() -> void:
	$save_screen.show()


func _on_start_save_pressed() -> void:
	await SaveLoad.load_save()
	#if SaveLoad.save_content.has_started_game:
		#print("a game was started")
	#else:
	get_tree().change_scene_to_file("res://scenes/worlds/normal_world.tscn")


func _on_close_save_screen_button_pressed() -> void:
	$save_screen.hide()
