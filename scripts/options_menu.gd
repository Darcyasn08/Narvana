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
