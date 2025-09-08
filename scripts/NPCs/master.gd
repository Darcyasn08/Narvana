extends Node3D

@export var npc_name: String = "master"
var portal_inst: Object = preload("res://scenes/first_level_portal.tscn")
var second_portal_inst: Object = preload("res://scenes/second_level_portal.tscn")

func _ready() -> void:
	if npc_name != null:
		$npc_manager.current_npc = npc_name
	#match Global.current_world:
		#Global.worlds.NORMAL:
			#npc_name = "master"
			#$npc_manager.current_npc = "master"
		#Global.worlds.FIRST_LEVEL:
			#npc_name = "master_first_level"
			#$npc_manager.current_npc = "master_first_level"
		#Global.worlds.SECOND_LEVEL:
			#npc_name = "master_second_level"
			#$npc_manager.current_npc = "master_second_level"
	print(npc_name)
	SignalBus.on_start_dialog_function.connect(open_portal)
	if npc_name == "second_master":
		if !Global.completed_levels["first_level"]:
			$npc_dialogue_area/CollisionShape3D.set_deferred("disabled", true)
			$master_model/body/StaticBody3D/CollisionShape3D.set_deferred("disabled", true)
			hide()
		else:
			$npc_dialogue_area/CollisionShape3D.set_deferred("disabled", false)
			$master_model/body/StaticBody3D/CollisionShape3D.set_deferred("disabled", false)
			show()

func open_portal(emmited_name: String, func_id: String) -> void:
	if emmited_name == npc_name:
		if func_id == "open_first_level_portal":
			var first_level_portal: Object = portal_inst.instantiate()
			first_level_portal.position = $portal_pos.position
			#Global.current_weapon = Global.weapons.BAT
			SignalBus.on_change_player_weapon.emit(Global.current_weapon)
			add_child(first_level_portal)
		if func_id == "open_second_level_portal":
			var second_level_portal: Object = second_portal_inst.instantiate()
			second_level_portal.position = $portal_pos.position
			#Global.current_weapon = Global.weapons.BAT
			SignalBus.on_change_player_weapon.emit(Global.current_weapon)
			add_child(second_level_portal)
