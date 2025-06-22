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
			get_tree().change_scene_to_file("res://scenes/first_level.tscn")
		elif Global.current_world == Global.worlds.FIRST_LEVEL:
			Global.player_can_attack = true
			Global.current_world = Global.worlds.NORMAL
			get_tree().change_scene_to_file("res://scenes/normal_world.tscn")
