extends CanvasLayer

# NOTA PARA MIM MESMA: fazer com que os frames no array sejam construidos na hora
# ou montar um array que tenha cada frame integrado nele

var is_ending: bool = false

func _ready() -> void:
	SignalBus.on_ignite_cutscene.connect(start_cutscene)
	hide()

func start_cutscene() -> void:
	show()
	is_ending = false
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$control/start_cutscene/start_cutscene_anim.play("start_cutscene")

func _on_start_cutscene_anim_animation_finished(anim_name: StringName) -> void:
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
	hide()
