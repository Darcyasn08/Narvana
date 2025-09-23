extends Node3D

func _ready() -> void:
	$loading_panel.show()
	$player.position = Global.player_normal_pos
	#Global.player_can_attack = false
	Global.current_world = Global.worlds.NORMAL
	await get_tree().create_timer(1).timeout
	$Camera3D.current = false
	$loading_panel/AnimationPlayer.play("fade_loading")
	await $loading_panel/AnimationPlayer.animation_finished
	$loading_panel.hide()
	print("visibility: ",$loading_panel.visible)
