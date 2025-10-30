extends Area3D

func _ready() -> void:
	$choice_canvas.hide()

func _on_stairs_button_pressed() -> void:
	SignalBus.on_item_removed.emit("coffee")
	get_tree().paused = false
	$choice_canvas.hide()
	#dar play na animação das escadas
	#await anim_player.animation_finished
	get_tree().change_scene_to_file("res://scenes/worlds/third_level.tscn")

func _on_bridge_button_pressed() -> void:
	SignalBus.on_item_removed.emit("plush")
	get_tree().paused = false
	$choice_canvas.hide()
	#dar play na animação da ponte
	#await anim_player.animation_finished
	get_tree().change_scene_to_file("res://scenes/worlds/third_level.tscn")


func _on_body_entered(body: Node3D) -> void:
	if body.name == "player":
		$choice_canvas.show()
		get_tree().paused = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
