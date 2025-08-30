extends CanvasLayer


func _on_back_button_pressed() -> void:
	hide()


func _on_control_settings_button_pressed() -> void:
	$controls_screen.show()


func _on_sensibility_scroll_scrolling() -> void:
	%sensibility_value.text = str(snapped(%sensibility_scroll.value,1))
	Global.mouse_sens = %sensibility_scroll.value / 700
	print(Global.mouse_sens)
	SignalBus.on_changed_mouse_sens.emit(Global.mouse_sens)
