extends CanvasLayer

func _ready() -> void:
	hide()

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("esc"):
		get_tree().paused = true
		show()

func _on_options_button_pressed() -> void:
	$button_container.show()
	$inventory_menu.hide()
	#$options_menu.show()
	#print("open options")

func _on_back_button_pressed() -> void:
	self.hide()
	get_tree().paused = false

func _on_inventory_button_pressed() -> void:
	$inventory_menu.show()
	$button_container.hide()

func _on_config_button_pressed() -> void:
	$options_menu.show()
