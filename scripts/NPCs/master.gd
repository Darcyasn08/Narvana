extends Node3D

var npc_name: String = "master"
var portal_inst: Object = preload("res://scenes/first_level_portal.tscn")

func _ready() -> void:
	await get_tree().create_timer(1).timeout
	match Global.current_world:
		Global.worlds.NORMAL:
			npc_name = "master"
			$npc_manager.current_npc = "master"
		Global.worlds.FIRST_LEVEL:
			npc_name = "master_first_level"
			$npc_manager.current_npc = "master_first_level"
		Global.worlds.SECOND_LEVEL:
			npc_name = "master_second_level"
			$npc_manager.current_npc = "master_second_level"
	print(npc_name)
	SignalBus.on_start_dialog_function.connect(open_portal)

func open_portal(emmited_name: String) -> void:
	if emmited_name == npc_name:
		var first_level_portal: Object = portal_inst.instantiate()
		first_level_portal.position = $portal_pos.position
		Global.current_weapon = "bat"
		SignalBus.on_change_player_weapon.emit(Global.current_weapon)
		add_child(first_level_portal)
