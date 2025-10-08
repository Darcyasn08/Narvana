extends Control

@export var id: int
@export var title: String
@export var info: String
@export var is_created: bool = false
@export var scene_to_load: String
@onready var hud_life_inst: Object = preload("res://scenes/UI/hud_life.tscn")

func _ready() -> void:
	SignalBus.on_delete_confirmed.connect(delete_save)
	if SaveLoad.save_content[id].get("was_opened") == null:
		SaveLoad.delete_all_saves()
		SaveLoad.save_content[id]["was_opened"] = false
	if SaveLoad.save_content[id]["was_opened"]:
		%title_label.text = title
		%info_label.text = str(SaveLoad.save_content[id])
		%sprite_created.show()
		%sprite_not_created.hide()
		%title_label.show()
		%health_label.show()
		#%health.show()
		%health_label.text = str("Vidas: ",SaveLoad.save_content[id]["health"])
		#%info_label.show()
		if SaveLoad.save_content[id].get("time_lapsed") != null:
			var time_in_minutes: int = snapped(SaveLoad.save_content[id]["time_lapsed"]/60,1)
			var time_in_seconds: int = (SaveLoad.save_content[id]["time_lapsed"]-(time_in_minutes*60))
			if time_in_seconds < 10:
				%time_label.text = str("Tempo: ",time_in_minutes,":0",time_in_seconds,"m")
			else:
				%time_label.text = str("Tempo: ",time_in_minutes,":",time_in_seconds,"m")
		for child: TextureRect in %health.get_children():
			child.queue_free()
		for heart: int in SaveLoad.save_content[id]["health"]:
			var hud_life: Object = hud_life_inst.instantiate()
			$Control/health.add_child(hud_life)
		%time_label.show()
		%new_save_button.hide()
		%open_save_button.show()
		%delete_save_button.show()
	else:
		%sprite_created.hide()
		%sprite_not_created.show()
		%title_label.hide()
		%info_label.hide()
		%health_label.hide()
		%time_label.hide()
		#%health.hide()
		%new_save_button.show()
		%open_save_button.hide()
		%delete_save_button.hide()
	custom_minimum_size.x = 450
	%new_save_button.pressed.connect(new_save_button_pressed)
	%open_save_button.pressed.connect(open_save_button_pressed)
	%delete_save_button.pressed.connect(delete_save_button_pressed)

func new_save_button_pressed() -> void:
	SaveLoad.save_content[id]["time_lapsed"] = 0
	%new_save_button.hide()
	%open_save_button.show()
	%delete_save_button.show()
	%title_label.show()
	%health_label.show()
	#%health.show()
	%time_label.show()
	%health_label.text = str("Vidas: ",SaveLoad.save_content[id]["health"])
	#%info_label.show()
	if SaveLoad.save_content[id].get("time_lapsed")!=null:
		var time_in_minutes: int = snapped(SaveLoad.save_content[id]["time_lapsed"]/60,1)
		var time_in_seconds: int = (SaveLoad.save_content[id]["time_lapsed"]-(time_in_minutes*60))
		#print("sec: ",time_in_seconds)
		if time_in_seconds < 10:
			%time_label.text = str("Tempo: ",time_in_minutes,":0",time_in_seconds,"m")
		else:
			%time_label.text = str("Tempo: ",time_in_minutes,":",time_in_seconds,"m")
	for heart: int in SaveLoad.save_content[id]["health"]:
		#print("health")
		var hud_life: Object = hud_life_inst.instantiate()
		$Control/health.add_child(hud_life)
	%sprite_created.show()
	%sprite_not_created.hide()
	%title_label.text = str("Jogo ",id+1)
	SaveLoad.save_content[id]["current_world"] = 0
	SaveLoad.save_content[id]["health"] = 7
	SaveLoad.save_content[id]["was_opened"] = false
	SaveLoad.save_content[id]["current_weapon"] = 1
	SaveLoad.save_content[id]["last_saved_pos"] = Vector3(0,0,-45)
	SaveLoad.save_content[id]["npc_manager"] = Global.reset_npc_manager.duplicate()
	SaveLoad.save_content[id]["cutscenes"] = Global.reset_cutscenes.duplicate()
	SaveLoad.save_content[id]["inventory"] = Global.reset_inventory.duplicate()
	SaveLoad.save_content[id]["mouse_sens"] = Global.mouse_sens
	SaveLoad.save_content[id]["rotation_mouse_axis_x"] = Global.rotation_mouse_axis_x
	SaveLoad.save_content[id]["rotation_mouse_axis_y"] = Global.rotation_mouse_axis_y
	SaveLoad.save_content[id]["completed_levels"] = Global.reset_completed_levels.duplicate()
	SaveLoad.save_content[id]["time_lapsed"] = 0
	# ^^^ dar um jeito de resetar o global do dialogo a cada save criado, sem sair do jogo
	#tipo, criar uma variável apenas salvando quem vc falou ou algo assim
	%info_label.text = str(SaveLoad.save_content[id])
	SaveLoad.save()

func open_save_button_pressed() -> void:
	Global.current_save = id
	print("open save:",Global.cutscenes, "--- reset: ",Global.reset_cutscenes)
	Global.player_can_move = true
	print(SaveLoad.save_content[id]["last_saved_pos"])
	Global.completed_levels = SaveLoad.save_content[id]["completed_levels"]
	SaveLoad.save_content[id]["was_opened"] = true
	SaveLoad.save()
	#print("var until now: ",SaveLoad.save_content[id])
	SaveLoad.load_to_global()
	if SaveLoad.save_content[id]["current_world"] != null:
		match SaveLoad.save_content[id]["current_world"]:
			0:
				Global.next_scene = "res://scenes/worlds/normal_world.tscn"
				get_tree().change_scene_to_packed(Global.loading_screen)
			1:
				Global.next_scene = "res://scenes/worlds/first_level.tscn"
				get_tree().change_scene_to_packed(Global.loading_screen)
			2:
				Global.next_scene = "res://scenes/worlds/second_level.tscn"
				get_tree().change_scene_to_packed(Global.loading_screen)

func delete_save_button_pressed() -> void:
	Global.current_save = id
	print("delete request: ",id)
	SignalBus.on_send_delete_request.emit(Global.current_save)

func delete_save(delete_panel: int) -> void:
	#print("delete panel: ",SaveLoad.save_content[delete_panel])
	SaveLoad.save()
	if id == delete_panel:
		print("before delete:",Global.cutscenes, "--- reset: ",Global.reset_cutscenes)
		SaveLoad.save_content[delete_panel] = SaveLoad.reset_save_content[delete_panel]
		print("after delete:",Global.cutscenes, "--- reset: ",Global.reset_cutscenes)
		%title_label.hide()
		%info_label.hide()
		%new_save_button.show()
		%time_label.hide()
		%health_label.hide()
		#%health.hide()
		for child: TextureRect in %health.get_children():
			child.queue_free()
		%open_save_button.hide()
		%delete_save_button.hide()
		%sprite_created.hide()
		%sprite_not_created.show()
	is_created = false
