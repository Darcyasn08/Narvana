extends CanvasLayer

func _ready() -> void:
	await get_tree().create_timer(.5).timeout
	#mudar os ícones e textos dos botões
	print(Global.current_world)
	if Global.current_world == Global.worlds.NORMAL:
		if !Global.completed_levels["first_level"]: #1°
			%item1_button.texture_normal = load(Global.inventory["items"]["car_keys"]["icon"])
			%item2_button.texture_normal = load(Global.inventory["items"]["jewel"]["icon"])
			%item1_label.text = str("-",Global.inventory["items"]["car_keys"]["buff"]["damage"]," dano")
			%item2_label.text = str("-",Global.inventory["items"]["jewel"]["buff"]["speed"]," velocidade")
		else: #2°
			%item1_button.texture_normal = load(Global.inventory["items"]["photo"]["icon"])
			%item2_button.texture_normal = load(Global.inventory["items"]["rings"]["icon"])
			%item1_label.text = str("-",Global.inventory["items"]["photo"]["buff"]["damage"]," dano")
			%item2_label.text = str("-",Global.inventory["items"]["rings"]["buff"]["health"]," vida")
	else: #3°
		%item1_button.texture_normal = load(Global.inventory["items"]["plush"]["icon"])
		%item2_button.texture_normal = load(Global.inventory["items"]["coffee"]["icon"])
		%item1_label.text = str("-",Global.inventory["items"]["plush"]["buff"]["health"]," vida")
		%item2_label.text = str("-",Global.inventory["items"]["coffee"]["buff"]["speed"]," velocidade")

func _on_item_1_button_pressed() -> void:
	if Global.current_world == Global.worlds.NORMAL:
		#caso não tenha completado primeira fase
		if !Global.completed_levels["first_level"]:
			SignalBus.on_item_removed.emit("car_keys")
		#caso tenha (segunda fase)
		else:
			SignalBus.on_item_removed.emit("photo")
	else: #em relação a terceira fase
		SignalBus.on_item_removed.emit("plush")
	get_tree().paused = false
	Global.player_can_move = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	hide()

func _on_item_2_button_pressed() -> void:
	if Global.current_world == Global.worlds.NORMAL:
		#caso não tenha completado primeira fase
		if !Global.completed_levels["first_level"]:
			SignalBus.on_item_removed.emit("jewel")
		#caso tenha (segunda fase)
		else:
			print("item foi removido")
			SignalBus.on_item_removed.emit("rings")
	else: #em relação a terceira fase
		SignalBus.on_item_removed.emit("coffee")
	get_tree().paused = false
	Global.player_can_move = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	hide()

func _on_item_1_button_mouse_entered() -> void:
	%item1_button.modulate = Color(0.585, 0.636, 0.864, 1.0)

func _on_item_1_button_mouse_exited() -> void:
	%item1_button.modulate = Color(1.0, 1.0, 1.0, 1.0)

func _on_item_2_button_mouse_entered() -> void:
	%item2_button.modulate = Color(0.585, 0.636, 0.864, 1.0)

func _on_item_2_button_mouse_exited() -> void:
	%item2_button.modulate = Color(1.0, 1.0, 1.0, 1.0)
