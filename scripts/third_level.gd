extends Node3D

var player_near_stairs: bool = false

func _ready() -> void:
	Global.current_world = Global.worlds.THIRD_LEVEL

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		Global.player_third_level_pos = Vector3(92,5,-71)
		Global.next_scene = "res://scenes/worlds/third_level_entrance.tscn"
		get_tree().change_scene_to_file("res://scenes/UI/loading_screen.tscn")

func _on_upstairs_area_body_entered(body: Node3D) -> void:
	if body.name == "player":
		player_near_stairs = true
		$upstairs_area/npc_interact_sign.show()

func _on_upstairs_area_body_exited(body: Node3D) -> void:
	if body.name == "player":
		player_near_stairs = false
		$upstairs_area/npc_interact_sign.hide()
