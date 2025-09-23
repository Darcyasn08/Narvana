extends Control

@export var id: int
@export var title: String
@export var info: String
@export var is_created: bool = false
@export var scene_to_load: String

func _ready() -> void:
	SignalBus.on_delete_confirmed.connect(delete_save)
	if is_created:
		%title_label.text = title
		%info_label.text = info
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
	if SaveLoad.save_content[id] == {}:
		%new_save_button.hide()
		%open_save_button.show()
		%delete_save_button.show()
		%title_label.show()
		%info_label.show()
		%sprite_created.show()
		%sprite_not_created.hide()
		%title_label.text = str("Save ",id+1)
		SaveLoad.save_content[id]["current_world"] = 0
		SaveLoad.save_content[id]["completed_levels"] = {}
		for level in Global.completed_levels:
			SaveLoad.save_content[id]["completed_levels"][level] = false
			Global.completed_levels[id] = false
		SaveLoad.save_content[id]["current_weapon"] = 1 #bat
		Global.current_weapon = SaveLoad.save_content[id]["current_weapon"]
		%info_label.text = str(SaveLoad.save_content[id])
		is_created = true
		SaveLoad.save_content[id]["is_created"] = is_created
		#print(SaveLoad.save_content)
		#print("created")
		SaveLoad.save()

func open_save_button_pressed() -> void:
	Global.completed_levels = SaveLoad.save_content[id]["completed_levels"]
	SaveLoad.load_to_global()
	if SaveLoad.save_content[id]["current_world"] != null:
		match SaveLoad.save_content[id]["current_world"]:
			0:
				Global.current_save = 0
				Global.next_scene = "res://scenes/worlds/normal_world.tscn"
				get_tree().change_scene_to_packed(Global.loading_screen)
			1:
				Global.current_save = 1
				Global.next_scene = "res://scenes/worlds/first_level.tscn"
				get_tree().change_scene_to_packed(Global.loading_screen)
			2:
				Global.current_save = 2
				Global.next_scene = "res://scenes/worlds/second_level.tscn"
				get_tree().change_scene_to_packed(Global.loading_screen)

func delete_save_button_pressed() -> void:
	SignalBus.on_send_delete_request.emit(id)

func delete_save(delete_panel: int) -> void:
	SaveLoad.save_content[delete_panel] = {}
	print("delete panel: ",delete_panel)
	SaveLoad.save()
	if id == delete_panel:
		%title_label.hide()
		%info_label.hide()
		%new_save_button.show()
		%open_save_button.hide()
		%delete_save_button.hide()
		%sprite_created.hide()
		%sprite_not_created.show()
