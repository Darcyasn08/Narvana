extends Node3D

func _ready() -> void:
	SaveLoad.load_save()
	$loading_panel.show()
	$player.position = Global.last_saved_pos
	#Global.player_can_attack = false
	Global.current_world = Global.worlds.NORMAL
	await get_tree().create_timer(1).timeout
	$Camera3D.current = false
	$loading_panel/AnimationPlayer.play("fade_loading")
	await $loading_panel/AnimationPlayer.animation_finished
	$loading_panel.hide()
	print("visibility: ",$loading_panel.visible)


func _on_cutscene_area_body_entered(body: Node3D) -> void:
	if body.name == "player":
		if Global.cutscenes["start"] == false:
			await get_tree().create_timer(1).timeout
			print("emmiting")
			SignalBus.on_ignite_cutscene.emit() #depois fazer com que emita o nome exato
