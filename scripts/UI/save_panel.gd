extends Control

@export var id: int
@export var title: String
@export var info: String
@export var is_created: bool = false
@export var scene_to_load: String

func _ready() -> void:
	SignalBus.on_delete_confirmed.connect(delete_save)
	if SaveLoad.save_content[id]["was_opened"]:
		%title_label.text = title
		%info_label.text = str(SaveLoad.save_content[id])
		%sprite_created.show()
		%sprite_not_created.hide()
		%title_label.show()
		%info_label.show()
		%new_save_button.hide()
		%open_save_button.show()
		%delete_save_button.show()
	else:
		%sprite_created.hide()
		%sprite_not_created.show()
		%title_label.hide()
		%info_label.hide()
		%new_save_button.show()
		%open_save_button.hide()
		%delete_save_button.hide()
	custom_minimum_size.x = 450
	%new_save_button.pressed.connect(new_save_button_pressed)
	%open_save_button.pressed.connect(open_save_button_pressed)
	%delete_save_button.pressed.connect(delete_save_button_pressed)

func new_save_button_pressed() -> void:
	#print("here: ",SaveLoad.save_content[id])
	%new_save_button.hide()
	%open_save_button.show()
	%delete_save_button.show()
	%title_label.show()
	%info_label.show()
	%sprite_created.show()
	%sprite_not_created.hide()
	%title_label.text = str("Save ",id+1)
	SaveLoad.save_content[id]["current_world"] = 0
	SaveLoad.save_content[id]["health"] = Global.player_health
	SaveLoad.save_content[Global.current_save]["current_weapon"] = Global.current_weapon
	SaveLoad.save_content[Global.current_save]["last_saved_pos"] = Global.last_saved_pos 
	SaveLoad.save_content[Global.current_save]["npc_manager"] = Global.npc_manager
	SaveLoad.save_content[Global.current_save]["cutscenes"] = Global.cutscenes
	SaveLoad.save_content[Global.current_save]["inventory"] = Global.inventory
	SaveLoad.save_content[Global.current_save]["mouse_sens"] = Global.mouse_sens
	SaveLoad.save_content[Global.current_save]["rotation_mouse_axis_x"] = Global.rotation_mouse_axis_x
	SaveLoad.save_content[Global.current_save]["rotation_mouse_axis_y"] = Global.rotation_mouse_axis_y
	SaveLoad.save_content[id]["completed_levels"] = {}
	for level in Global.completed_levels:
		SaveLoad.save_content[id]["completed_levels"][level] = false
		Global.completed_levels[id] = false
	# ^^^ dar um jeito de resetar o global do dialogo a cada save criado, sem sair do jogo
	#tipo, criar uma variável apenas salvando quem vc falou ou algo assim
	%info_label.text = str(SaveLoad.save_content[id])
	SaveLoad.save()

func open_save_button_pressed() -> void:
	Global.completed_levels = SaveLoad.save_content[id]["completed_levels"]
	SaveLoad.save_content[id]["was_opened"] = true
	SaveLoad.save()
	Global.current_save = id
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
	SignalBus.on_send_delete_request.emit(id)

func delete_save(delete_panel: int) -> void:
	SaveLoad.save_content[delete_panel] = SaveLoad.reset_save_content[delete_panel]
	#print("delete panel: ",SaveLoad.save_content[delete_panel])
	SaveLoad.save()
	if id == delete_panel:
		%title_label.hide()
		%info_label.hide()
		%new_save_button.show()
		%open_save_button.hide()
		%delete_save_button.hide()
		%sprite_created.hide()
		%sprite_not_created.show()
	is_created = false

func add_var_to_new_save() -> void:
	SaveLoad.save_content[id]["current_weapon"] = 1 #bat
	Global.current_weapon = SaveLoad.save_content[id]["current_weapon"]
	is_created = true
	SaveLoad.save_content[id]["is_created"] = is_created
	SaveLoad.save_content[id]["health"] = Global.player_health
	SaveLoad.save_content[id]["last_saved_pos"] = Vector3(0,0,-26)
	SaveLoad.save_content[id]["npc_manager"] = Global.npc_manager
	SaveLoad.save_content[id]["cutscenes"] = Global.cutscenes
	SaveLoad.save_content[id]["rotation_mouse_axis_x"] = Global.rotation_mouse_axis_x
	SaveLoad.save_content[id]["rotation_mouse_axis_y"] = Global.rotation_mouse_axis_y

#variáveis adicionadas depois
func add_var_to_save() -> void:
	if SaveLoad.save_content[id].get("inventory") == null:
		SaveLoad.save_content[id]["inventory"] = Global.inventory
		SaveLoad.save_content[id]["mouse_sens"] = Global.mouse_sens
		SaveLoad.save_content[id]["rotation_mouse_axis_x"] = Global.rotation_mouse_axis_x
		SaveLoad.save_content[id]["rotation_mouse_axis_y"] = Global.rotation_mouse_axis_y
	SaveLoad.save()
