extends Area3D



func _ready() -> void:
	pass 



func _process(delta: float) -> void:
	pass


func _on_area_entered(area: Area3D) -> void:
	$Timer.start()
	print("timer started")
	if area.is_in_group("weapon"):
		Global.house_health -= Global.player_damage * 2


func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/player/test_world.tscn")
