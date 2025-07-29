extends CanvasLayer

@onready var current_world_label: Label = $"save_screen/HBoxContainer/0/current_world_label"
var cur_world: int
var loading_screen_inst: Object = preload("res://scenes/UI/loading_screen.tscn")
@onready var loading_screen: Object = loading_screen_inst.instantiate()

func _ready() -> void:
	await SaveLoad.load_save()
	
	match SaveLoad.save_content.current_world:
		0:
			current_world_label.text = str("mundo atual: China")
			cur_world = 0
		1:
			current_world_label.text = str("mundo atual: Primeira fase")
			cur_world = 1
		2:
			current_world_label.text = str("mundo atual: Segunda fase")
			cur_world = 2
	
	$"save_screen/HBoxContainer/0/Label3".text = str("Vida atual: ",Global.player_health)


func _on_start_button_pressed() -> void:
	$save_screen.show()


func _on_start_save_pressed() -> void:
	match cur_world:
		0:
			Global.next_scene = "res://scenes/worlds/normal_world.tscn"
			get_tree().change_scene_to_packed(Global.loading_screen)
		1:
			Global.next_scene = "res://scenes/worlds/first_level.tscn"
			get_tree().change_scene_to_packed(Global.loading_screen)
		2:
			get_tree().change_scene_to_file("res://scenes/worlds/second_level.tscn")


func _on_close_save_screen_button_pressed() -> void:
	$save_screen.hide()
