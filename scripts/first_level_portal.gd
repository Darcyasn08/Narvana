extends Area3D

var player_near: bool = false

func _on_body_entered(body: Node3D) -> void:
	if body.name == "player":
		player_near = true

func _on_body_exited(body: Node3D) -> void:
	if body.name == "player":
		player_near = false

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("e") and player_near:
		if Global.current_world == Global.worlds.NORMAL:
			Global.player_can_attack = true
			Global.current_world = Global.worlds.FIRST_LEVEL
			print("teleportando..")
			Global.next_scene = "res://scenes/worlds/first_level.tscn"
			get_tree().change_scene_to_packed(Global.loading_screen)
		elif Global.current_world == Global.worlds.FIRST_LEVEL:
			Global.player_can_attack = true
			Global.player_normal_pos = Vector3(90,2,113)
			Global.current_world = Global.worlds.NORMAL
			Global.next_scene = "res://scenes/worlds/normal_world.tscn"
			get_tree().change_scene_to_packed(Global.loading_screen)
