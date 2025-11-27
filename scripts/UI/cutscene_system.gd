extends CanvasLayer

# NOTA PARA MIM MESMA: fazer com que os frames no array sejam construidos na hora
# ou montar um array que tenha cada frame integrado nele

var current_cutscene: String = ""
var is_ending: bool = false

func _ready() -> void:
	SignalBus.on_ignite_cutscene.connect(start_cutscene)
	hide()

func start_cutscene(cutscene: String) -> void:
	current_cutscene = cutscene
	show()
	$control.get_node(cutscene).show()
	is_ending = false
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	%cutscene_player.play(cutscene)

func _on_start_cutscene_anim_animation_finished(_anim_name: StringName) -> void:
	if !is_ending:
		end_cutscene()

func _on_skip_cutscene_pressed() -> void:
	end_cutscene()

func end_cutscene() -> void:
	is_ending = true
	$AnimationPlayer.play("fade_out")
	await $AnimationPlayer.animation_finished
	get_tree().paused = false
	Global.cutscenes["start"] = true
	if current_cutscene == "final":
		get_tree().change_scene_to_file("res://scenes/UI/credits_menu.tscn")
	else:
		$control.get_node(current_cutscene).hide()
		hide()
