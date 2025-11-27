extends CanvasLayer

@onready var click_sfx: AudioStreamPlayer2D = $click_sfx

func _ready() -> void:
	hide()
	SaveLoad.load_save()
	SignalBus.on_player_health_changed.emit(Global.player_health)
	$inventory_selected.hide()

func _physics_process(_delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("esc") or event.is_action_pressed("tab") and get_tree().paused == false:
		if !visible:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			get_tree().paused = true
			Global.game_paused = true
			show()
			$AnimationPlayer.play("fade_in")
			SignalBus.on_game_paused.emit(Global.game_paused)
		else:
			hide()
			get_tree().paused = false
			Global.game_paused = false
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			SignalBus.on_game_paused.emit(Global.game_paused)

func _on_options_button_pressed() -> void:
	$button_container.show()
	$inventory_menu.hide()
	$inventory_selected.hide()
	$options_selected.show()
	#$options_menu.show()
	#print("open options")

func _on_back_button_pressed() -> void:
	click_sfx.play()
	hide()
	get_tree().paused = false
	Global.game_paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	SignalBus.on_game_paused.emit(Global.game_paused)

func _on_inventory_button_pressed() -> void:
	$inventory_menu.show()
	$button_container.hide()
	$inventory_selected.show()
	$options_selected.hide()

func _on_config_button_pressed() -> void:
	click_sfx.play()
	$options_menu.show()

func _on_quit_button_pressed() -> void:
	click_sfx.play()
	get_tree().paused = false
	await get_tree().create_timer(.3).timeout
	Global.next_scene = "res://scenes/UI/start_menu.tscn"
	get_tree().change_scene_to_packed(Global.loading_screen)
	#get_tree().quit()

func _on_save_button_pressed() -> void:
	click_sfx.play()
	save()

func _on_reset_health_button_pressed() -> void:
	click_sfx.play()
	Global.player_health = Global.max_player_health
	SignalBus.on_player_health_changed.emit(Global.player_health)
	#print(Global.max_player_health)

func save() -> void:
	SignalBus.on_game_saved.emit()
	$save_label.show()
	SaveLoad.save_to_file()
	SaveLoad.save()
	await get_tree().create_timer(1.7).timeout
	$save_label.hide()

func _on_timer_timeout() -> void:
	if !get_tree().paused:
		Global.time_lapsed += 1

func _on_autosave_timer_timeout() -> void:
	print("autosave")
	print(Global.time_lapsed)
	save()
