extends Node3D

@export var npc_name: String = "master"
@export var end_of_level: bool = false
var portal_inst: Object = preload("res://scenes/first_level_portal.tscn")
var item_thrower_inst: Object = preload("res://scenes/item_thrower.tscn")
var second_portal_inst: Object = preload("res://scenes/second_level_portal.tscn")

func _ready() -> void:
	if npc_name != null:
		$npc_manager.current_npc = npc_name
	SignalBus.on_start_dialog_function.connect(open_portal)
	if npc_name == "second_master":
		if !Global.completed_levels["first_level"]:
			$npc_dialogue_area/CollisionShape3D.set_deferred("disabled", true)
			$StaticBody3D/CollisionShape3D.set_deferred("disabled", true)
			hide()
		else:
			$npc_dialogue_area/CollisionShape3D.set_deferred("disabled", false)
			$StaticBody3D/CollisionShape3D.set_deferred("disabled", false)
			show()
	if Global.completed_levels["first_level"] and npc_name == "master":
		hide()
	if Global.completed_levels["second_level"]:
		hide()
		#simular que o mestre morreu, fazendo todos os outros sumirem

func _physics_process(_delta: float) -> void:
	if end_of_level:
		if Global.completed_levels["first_level"]:
			show()
		else:
			hide()
	await(get_tree().create_timer(.1).timeout)

func open_portal(emmited_name: String, func_id: String) -> void:
	if emmited_name == npc_name:
		if func_id == "open_first_level_portal":
			Global.current_mission = 1
			SignalBus.on_mission_list_updated.emit(Global.missions[1])
			var item_thrower: Object = item_thrower_inst.instantiate()
			item_thrower.position = position + $portal_pos.position
			get_parent().add_child(item_thrower)
			Global.current_weapon = Global.weapons.BAT
			SignalBus.on_change_player_weapon.emit(Global.current_weapon)
			#add_child(first_level_portal)
		if func_id == "open_second_level_portal":
			var second_level_portal: Object = second_portal_inst.instantiate()
			second_level_portal.position = $portal_pos.position
			#Global.current_weapon = Global.weapons.BAT
			SignalBus.on_change_player_weapon.emit(Global.current_weapon)
			add_child(second_level_portal)
