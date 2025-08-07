extends Area3D

var alr_enter: bool = false

func _ready() -> void:
	pass 

func _process(delta: float) -> void:
	pass

func _on_area_entered(area: Area3D) -> void:
	if !alr_enter:
		alr_enter = true
		$Timer.start()
		print("timer started")
	if area.is_in_group("weapon"):
		Global.house_health -= Global.player_damage * 2

func _on_timer_timeout() -> void:
	print("change world")
	#get_tree().change_scene_to_file("res://scenes/player/test_world.tscn")
