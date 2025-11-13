extends CanvasLayer


func _on_item_1_button_pressed() -> void:
	SignalBus.on_item_removed.emit("car_keys")
	print(Global.player_health)
	get_tree().paused = false
	Global.player_can_move = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	hide()

func _on_item_2_button_pressed() -> void:
	SignalBus.on_item_removed.emit("plush")
	print(Global.player_health)
	get_tree().paused = false
	Global.player_can_move = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	hide()
