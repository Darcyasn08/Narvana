extends CanvasLayer

var cur_world: int
var loading_screen_inst: Object = preload("res://scenes/UI/loading_screen.tscn")
var save_qtd: int = 0
@onready var loading_screen: Object = loading_screen_inst.instantiate()
var save_panel_inst: Object = preload("res://scenes/UI/save_panel.tscn")

var delete_panel: int = -1

func _ready() -> void:
	SaveLoad.load_save()
	$save_screen.hide()
	$confirm_delete_save.hide()
	SignalBus.on_send_delete_request.connect(show_confirm_delete_save)
	
	for save: int in SaveLoad.save_content:
		var save_panel: Object = save_panel_inst.instantiate()
		if SaveLoad.save_content[save] != {}:
			save_panel.is_created = true
			#print(SaveLoad.save_content[save])
		save_panel.id = save_qtd
		save_panel.title = str("Jogo ",save_qtd+1)
		save_panel.info = str(SaveLoad.save_content[save])
		$save_screen/HBoxContainer.add_child(save_panel)
		save_qtd += 1
	
	if save_qtd == 0:
		var save_panel: Object = save_panel_inst.instantiate()
		save_panel.id = save_qtd
		$save_screen/HBoxContainer.add_child(save_panel)


func _on_start_button_pressed() -> void:
	Global.next_scene = "res://scenes/worlds/normal_world.tscn"
	get_tree().change_scene_to_packed(Global.loading_screen)


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

func show_confirm_delete_save(id: int) -> void:
	delete_panel = id
	print(delete_panel)
	$confirm_delete_save.show()
	$confirm_delete_save/AnimationPlayer.play("show_confirm_delete")

func _on_delete_save_button_pressed() -> void:
	SignalBus.on_delete_confirmed.emit(delete_panel)
	delete_panel = -1
	$confirm_delete_save.hide()

func _on_back_delete_button_pressed() -> void:
	$confirm_delete_save.hide()
	delete_panel = -1

func _on_open_save_screen_button_pressed() -> void:
	$save_screen.show()
	$save_screen/AnimationPlayer.play("show_save_screen")

func _on_options_button_pressed() -> void:
	$options_menu.show()

func _on_quit_button_pressed() -> void:
	get_tree().quit()
