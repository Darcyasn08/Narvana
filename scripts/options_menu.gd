extends CanvasLayer

func _ready() -> void:
	match Global.rotation_mouse_axis_y:
		1:
			$controls_screen/Label2/mouse_y_invert.button_pressed = false
		-1:
			$controls_screen/Label2/mouse_y_invert.button_pressed = true
	match Global.rotation_mouse_axis_x:
		1:
			$controls_screen/Label3/mouse_x_invert.button_pressed = false
		-1:
			$controls_screen/Label3/mouse_x_invert.button_pressed = true
	%sensibility_scroll.value = Global.mouse_sens * 700
	%sensibility_value.text = str(snapped(%sensibility_scroll.value,1))

func _on_back_button_pressed() -> void:
	hide()

func _on_control_settings_button_pressed() -> void:
	$controls_screen.show()

func _on_sensibility_scroll_scrolling() -> void:
	%sensibility_value.text = str(snapped(%sensibility_scroll.value,1))
	Global.mouse_sens = %sensibility_scroll.value / 700
	print(Global.mouse_sens)
	SignalBus.on_changed_mouse_sens.emit(Global.mouse_sens)

func _on_mouse_y_invert_pressed() -> void:
	match Global.rotation_mouse_axis_y:
		1:
			Global.rotation_mouse_axis_y = -1
		-1:
			Global.rotation_mouse_axis_y = 1

func _on_mouse_x_invert_pressed() -> void:
	match Global.rotation_mouse_axis_x:
		1:
			Global.rotation_mouse_axis_x = -1
		-1:
			Global.rotation_mouse_axis_x = 1

func _on_delete_saves_button_pressed() -> void:
	SaveLoad.delete_all_saves()

func _on_master_volume_scroll_scrolling() -> void:
	print(%master_volume_value.text)
	$%master_volume_value.text = str(snapped(%master_volume_scroll.value,0.1))
	AudioServer.set_bus_volume_db(0, linear_to_db(int(%master_volume_scroll.value)))

func _on_credits_button_pressed() -> void:
	pass # Replace with function body.

func _on_open_second_level_pressed() -> void:
	Global.next_scene = "res://scenes/worlds/second_level.tscn"
	get_tree().change_scene_to_packed(Global.loading_screen)
