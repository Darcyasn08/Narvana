extends Node

#https://www.youtube.com/watch?v=xG2GGniUa5o
var save_path: String = "user://narvana_save.json"

var save_content: Dictionary = {
	0: {
		"was_opened": false,
		"current_world": 0,
		"current_weapon": 1,
		"last_saved_pos": Vector3(0,0,-26),
		"npc_manager": Global.npc_manager,
		"health": Global.player_health,
		"completed_levels": Global.completed_levels,
		"cutscenes": Global.cutscenes,
		"inventory": Global.inventory,
		"mouse_sens": Global.mouse_sens,
		"rotation_mouse_axis_x": Global.rotation_mouse_axis_x,
		"rotation_mouse_axis_y": Global.rotation_mouse_axis_y,
	},
	1: {
		"was_opened": false,
		"current_world": 0,
		"current_weapon": 1,
		"last_saved_pos": Vector3(0,0,-26),
		"npc_manager": Global.npc_manager,
		"health": Global.player_health,
		"completed_levels": Global.completed_levels,
		"cutscenes": Global.cutscenes,
		"inventory": Global.inventory,
		"mouse_sens": Global.mouse_sens,
		"rotation_mouse_axis_x": Global.rotation_mouse_axis_x,
		"rotation_mouse_axis_y": Global.rotation_mouse_axis_y,
	},
	2: {
		"was_opened": false,
		"current_world": 0,
		"current_weapon": 1,
		"last_saved_pos": Vector3(0,0,-26),
		"npc_manager": Global.npc_manager,
		"health": Global.player_health,
		"completed_levels": Global.completed_levels,
		"cutscenes": Global.cutscenes,
		"inventory": Global.inventory,
		"mouse_sens": Global.mouse_sens,
		"rotation_mouse_axis_x": Global.rotation_mouse_axis_x,
		"rotation_mouse_axis_y": Global.rotation_mouse_axis_y,
	}
}

var reset_save_content: Dictionary = {
	0: {
		"was_opened": false,
		"current_world": 0,
		"current_weapon": 1,
		"last_saved_pos": Vector3(0,0,-26),
		"npc_manager": Global.npc_manager,
		"health": 7,
		"completed_levels": Global.completed_levels,
		"cutscenes": Global.cutscenes,
		"inventory": Global.inventory,
		"mouse_sens": Global.mouse_sens,
		"rotation_mouse_axis_x": Global.rotation_mouse_axis_x,
		"rotation_mouse_axis_y": Global.rotation_mouse_axis_y,
	},
	1: {
		"was_opened": false,
		"current_world": 0,
		"current_weapon": 1,
		"last_saved_pos": Vector3(0,0,-26),
		"npc_manager": Global.npc_manager,
		"health": 7,
		"completed_levels": Global.completed_levels,
		"cutscenes": Global.cutscenes,
		"inventory": Global.inventory,
		"mouse_sens": Global.mouse_sens,
		"rotation_mouse_axis_x": Global.rotation_mouse_axis_x,
		"rotation_mouse_axis_y": Global.rotation_mouse_axis_y,
	},
	2: {
		"was_opened": false,
		"current_world": 0,
		"current_weapon": 1,
		"last_saved_pos": Vector3(0,0,-26),
		"npc_manager": Global.npc_manager,
		"health": 7,
		"completed_levels": Global.completed_levels,
		"cutscenes": Global.cutscenes,
		"inventory": Global.inventory,
		"mouse_sens": Global.mouse_sens,
		"rotation_mouse_axis_x": Global.rotation_mouse_axis_x,
		"rotation_mouse_axis_y": Global.rotation_mouse_axis_y,
	}
}

func _ready() -> void:
	load_save()
	#if save_content.has_started_game:
		#print("game has started!")
	#else:
		#print("game hasnt started yet... show start cutscene")

func save() -> void:
	var file = FileAccess.open_encrypted_with_pass(save_path, FileAccess.WRITE, "narval")
	file.store_var(save_content.duplicate())
	file.close()
	print("jogo salvo!")
	#print(save_content)

func load_to_global() -> void:
	#salvar no global as variáveis básicas
	Global.completed_levels = save_content[Global.current_save]["completed_levels"]
	Global.player_health = SaveLoad.save_content[Global.current_save]["health"]
	Global.current_world = SaveLoad.save_content[Global.current_save]["current_world"]
	Global.current_weapon = SaveLoad.save_content[Global.current_save]["current_weapon"]
	Global.last_saved_pos = SaveLoad.save_content[Global.current_save]["last_saved_pos"]
	Global.npc_manager = SaveLoad.save_content[Global.current_save]["npc_manager"]
	Global.cutscenes = SaveLoad.save_content[Global.current_save]["cutscenes"]
	Global.inventory = SaveLoad.save_content[Global.current_save]["inventory"]
	Global.mouse_sens = SaveLoad.save_content[Global.current_save]["mouse_sens"]
	Global.rotation_mouse_axis_x = SaveLoad.save_content[Global.current_save]["rotation_mouse_axis_x"]
	Global.rotation_mouse_axis_y = SaveLoad.save_content[Global.current_save]["rotation_mouse_axis_y"]

func save_to_file() -> void:
	SignalBus.on_game_saved.emit()
	await get_tree().create_timer(.2).timeout
	SaveLoad.save_content[Global.current_save]["current_world"] = Global.current_world
	SaveLoad.save_content[Global.current_save]["health"] = Global.player_health
	SaveLoad.save_content[Global.current_save]["completed_levels"] = Global.completed_levels
	SaveLoad.save_content[Global.current_save]["current_weapon"] = Global.current_weapon
	SaveLoad.save_content[Global.current_save]["last_saved_pos"] = Global.last_saved_pos 
	SaveLoad.save_content[Global.current_save]["npc_manager"] = Global.npc_manager
	SaveLoad.save_content[Global.current_save]["cutscenes"] = Global.cutscenes
	SaveLoad.save_content[Global.current_save]["inventory"] = Global.inventory
	SaveLoad.save_content[Global.current_save]["mouse_sens"] = Global.mouse_sens
	SaveLoad.save_content[Global.current_save]["rotation_mouse_axis_x"] = Global.rotation_mouse_axis_x
	SaveLoad.save_content[Global.current_save]["rotation_mouse_axis_y"] = Global.rotation_mouse_axis_y
	#fazer isso realmente funcionar ^^^
	SaveLoad.save()

func load_save() -> void:
	if FileAccess.file_exists(save_path):
		#print("save exists")
		var file = FileAccess.open_encrypted_with_pass(save_path, FileAccess.READ, "narval")
		var data = file.get_var()
		file.close()
		
		var save_data = data.duplicate()
		save_content = save_data
		#print('SAVE DATA: ',save_data)

func delete_save(id: int) -> void:
	if FileAccess.file_exists(save_path):
		print("deleted!")
		DirAccess.remove_absolute(save_path)
		save_content[id] = reset_save_content[id]
		save()
		get_tree().reload_current_scene()

func delete_all_saves() -> void:
	if FileAccess.file_exists(save_path):
		print("deleted!")
		DirAccess.remove_absolute(save_path)
		save_content = reset_save_content
		save()
		get_tree().reload_current_scene()
