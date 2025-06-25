extends CanvasLayer

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true

func _on_retry_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
