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

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_save_button_pressed() -> void:
	pass # Replace with function body.

func save() -> Dictionary:
	var save_dict = {
		"health": 6,
		"magic_selec": 2,
	}
	return save_dict


func save_game() -> void:
	var save_game = FileAccess.open("user://arquivo_save_jogo.save", FileAccess.WRITE)
	var json_string = JSON.stringify(save())
	save_game.store_var(6) #health

func load_game() -> void:
	if not FileAccess.file_exists("user://arquivo_save_jogo.save"):
		return
	
	var save_game = FileAccess.open("user://arquivo_save_jogo.save", FileAccess.READ)
	
	while save_game.get_position() < save_game.get_length():
		var json_string = save_game.get_line()
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		var node_data = json.get_data()
		
		print(node_data)
