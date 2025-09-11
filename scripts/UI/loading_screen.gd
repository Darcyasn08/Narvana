extends CanvasLayer

func _ready() -> void:
	await get_tree().create_timer(.1).timeout
	ResourceLoader.load_threaded_request(Global.next_scene)

func _process(_delta: float) -> void:
	var progress: Array = []
	ResourceLoader.load_threaded_get_status(Global.next_scene, progress)
	$Control/ProgressBar.value = progress[0]*100
	
	if progress[0] == 1:
		#await get_tree().create_timer(1).timeout
		var packed_scene = ResourceLoader.load_threaded_get(Global.next_scene)
		get_tree().change_scene_to_packed(packed_scene)
