extends Node3D

func _ready() -> void:
	SaveLoad.load_save()
	$loading_panel.show()
	Global.player_health = Global.max_player_health
	SignalBus.on_player_health_changed.emit(Global.player_health)
	$player.position = Global.last_saved_pos
	Global.current_world = Global.worlds.NORMAL
	await get_tree().create_timer(1).timeout
	load_camera()

func load_camera() -> void:
	$Camera3D.current = false
	$loading_panel/AnimationPlayer.play("fade_loading")
	await $loading_panel/AnimationPlayer.animation_finished
	$loading_panel.hide()

func _on_cutscene_area_body_entered(body: Node3D) -> void:
	if body.name == "player":
		if Global.cutscenes["start"] == false:
			await get_tree().create_timer(1).timeout
			SignalBus.on_ignite_cutscene.emit("start") #depois fazer com que emita o nome exato

func _on_enter_temple_area_body_entered(body: Node3D) -> void:
	if body.name == "player":
		Global.missions[0]["done"] = true
		SignalBus.on_mission_list_updated.emit(Global.missions[0])
