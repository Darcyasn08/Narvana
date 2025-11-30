extends Area3D


func _on_body_entered(body: Node3D) -> void:
	if body.name == "player":
		$"../abism_bridge/bridge_anim".play("fall")
		await $"../abism_bridge/bridge_anim".animation_finished
		get_tree().change_scene_to_file("res://scenes/worlds/third_level.tscn")
		
