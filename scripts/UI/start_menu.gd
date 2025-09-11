extends CanvasLayer

@onready var current_world_label: Label = $"save_screen/HBoxContainer/0/current_world_label"
var cur_world: int
var loading_screen_inst: Object = preload("res://scenes/UI/loading_screen.tscn")
var save_qtd: int = 0
@onready var loading_screen: Object = loading_screen_inst.instantiate()
var save_panel_inst: Object = preload("res://scenes/UI/save_panel.tscn")

func _ready() -> void:
	await SaveLoad.load_save()
	$save_screen.hide()
	
	for save in SaveLoad.save_content:
		print("theres a save: ",save)
		var save_panel: Object = save_panel_inst.instantiate()
		if SaveLoad.save_content[save] != {}:
			save_panel.is_created = true
			print(SaveLoad.save_content[save])
		save_panel.id = save_qtd
		save_panel.title = str("Save ",save_qtd+1)
		save_panel.info += str("\n",Global.player_health)
		$save_screen/HBoxContainer.add_child(save_panel)
		save_qtd += 1
	
	if save_qtd == 0:
		var save_panel: Object = save_panel_inst.instantiate()
		save_panel.id = save_qtd
		print("save id: ",save_qtd)
		$save_screen/HBoxContainer.add_child(save_panel)
	#$"save_screen/HBoxContainer/0/Label3".text = str("Vida atual: ",Global.player_health)


func _on_start_button_pressed() -> void:
	$save_screen.show()
	$save_screen/AnimationPlayer.play("show_save_screen")


func _on_start_save_pressed() -> void:
	match cur_world:
		0:
			Global.next_scene = "res://scenes/worlds/normal_world.tscn"
			get_tree().change_scene_to_packed(Global.loading_screen)
		1:
			Global.next_scene = "res://scenes/worlds/first_level.tscn"
			get_tree().change_scene_to_packed(Global.loading_screen)
		2:
			Global.next_scene = "res://scenes/worlds/second_level.tscn"
			get_tree().change_scene_to_packed(Global.loading_screen)


func _on_close_save_screen_button_pressed() -> void:
	$save_screen/AnimationPlayer.play("RESET")
	$save_screen.hide()
