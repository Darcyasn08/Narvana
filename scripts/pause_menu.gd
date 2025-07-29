extends CanvasLayer

@onready var click_sfx: AudioStreamPlayer2D = $click_sfx

func _ready() -> void:
	hide()
	SaveLoad.load_save()
	SignalBus.on_player_health_changed.emit(Global.player_health)

func _physics_process(_delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().paused = true
		Global.game_paused = true
		show()
		SignalBus.on_game_paused.emit(Global.game_paused)

func _on_options_button_pressed() -> void:
	$button_container.show()
	$inventory_menu.hide()
	#$options_menu.show()
	#print("open options")

func _on_back_button_pressed() -> void:
	click_sfx.play()
	get_tree().paused = false
	hide()
	Global.game_paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	SignalBus.on_game_paused.emit(Global.game_paused)

func _on_inventory_button_pressed() -> void:
	$inventory_menu.show()
	$button_container.hide()

func _on_config_button_pressed() -> void:
	click_sfx.play()
	$options_menu.show()

func _on_quit_button_pressed() -> void:
	click_sfx.play()
	save()
	await get_tree().create_timer(1).timeout
	get_tree().quit()

func _on_save_button_pressed() -> void:
	click_sfx.play()
	save()

func _on_reset_health_button_pressed() -> void:
	click_sfx.play()
	Global.player_health = Global.max_player_health
	SignalBus.on_player_health_changed.emit(Global.player_health)
	#print(Global.max_player_health)

func save() -> void:
	SaveLoad.save_content.current_world = Global.current_world
	SaveLoad.save_content.health = Global.player_health
	SaveLoad.save_content.inventory = Global.inventory
	print(Global.inventory)
	Global.has_started_game = true
	SaveLoad.save_content.has_started_game = Global.has_started_game
	SaveLoad.save()
