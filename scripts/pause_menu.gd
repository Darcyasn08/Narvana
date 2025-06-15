extends CanvasLayer

func _ready() -> void:
	hide()

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("esc"):
		get_tree().paused = true
		show()

func _on_options_button_pressed() -> void:
	$options_menu.show()
	print("open options")

func _on_back_button_pressed() -> void:
	self.hide()
	get_tree().paused = false
