extends Area3D

var player_near: bool = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack") and player_near:
		print("boulder destroyed")
		$third_level_entrance/CollisionShape3D.set_deferred("disabled", false)
		$boulder_col/CollisionShape3D.set_deferred("disabled", true)
		$"blocking-boulder".hide()

func _on_body_entered(body: Node3D) -> void:
	if body.name == "player":
		player_near = true

func _on_third_level_entrance_body_entered(body: Node3D) -> void:
	if body.name == "player":
		Global.next_scene = "res://scenes/worlds/third_level_entrance.tscn"
		get_tree().change_scene_to_packed(Global.loading_screen)
