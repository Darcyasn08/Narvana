extends Control


func _on_item_1_button_pressed() -> void:
	SignalBus.on_item_removed.emit("photo")
	get_tree().paused = false
	Global.player_can_move = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	hide()

func _on_item_2_button_pressed() -> void:
	SignalBus.on_item_removed.emit("teddy")
	get_tree().paused = false
	Global.player_can_move = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	hide()
