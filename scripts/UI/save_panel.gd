extends Control

@export var id: int
@export var title: String
@export var info: String
@export var is_created: bool = false
@export var scene_to_load: String

func _ready() -> void:
	if is_created:
		$title_label.text = title
		$info_label.text = info
		$title_label.show()
		$info_label.show()
		$new_save_button.hide()
		$open_save_button.show()
		$delete_save_button.show()
	else:
		$title_label.hide()
		$info_label.hide()
		$new_save_button.show()
		$open_save_button.hide()
		$delete_save_button.hide()
	custom_minimum_size.x = 450
	$new_save_button.pressed.connect(new_save_button_pressed)
	$open_save_button.pressed.connect(open_save_button_pressed)
	$delete_save_button.pressed.connect(delete_save_button_pressed)

func new_save_button_pressed() -> void:
	if SaveLoad.save_content[id] == {}:
		$new_save_button.hide()
		$open_save_button.show()
		$delete_save_button.show()
		$title_label.show()
		$info_label.show()
		$title_label.text = str("Save ",id+1)
		SaveLoad.save_content[id]["current_world"] = 0
		$info_label.text = str("Mundo atual: ",SaveLoad.save_content[id]["current_world"])
		is_created = true
		SaveLoad.save_content[id]["is_created"] = is_created
		#print(SaveLoad.save_content)
		SaveLoad.save()

func open_save_button_pressed() -> void:
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
	SaveLoad.save_content[id] = {}
	$title_label.hide()
	$info_label.hide()
	$new_save_button.show()
	$open_save_button.hide()
	$delete_save_button.hide()
