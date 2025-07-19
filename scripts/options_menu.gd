extends CanvasLayer


func _on_back_button_pressed() -> void:
	hide()


func _on_control_settings_button_pressed() -> void:
	$controls_screen.show()
