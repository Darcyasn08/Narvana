extends Node3D

var normal_world_array: Array = []
var first_level_array: Array = []
var second_level_array: Array = []

var song_index: int = 0

@onready var pause: AudioStreamPlayer3D = $first_level/pause

func _ready() -> void:
	SignalBus.on_game_paused.connect(start_pause_song)
	for child in $first_level/main.get_children():
		first_level_array.append(child)
	for child in $first_level/main.get_children():
		first_level_array.append(child)
	for child in $second_level/main.get_children():
		second_level_array.append(child)


func start_pause_song(is_paused: bool) -> void:
	if is_paused:
		pause.play()
	else:
		pause.stop()


func _on_timer_timeout() -> void:
	match Global.current_world:
		Global.worlds.NORMAL:
			first_level_array[song_index].play()
			song_index += 1
			if song_index > first_level_array.size() - 1:
				$Timer.stop()
			else:
				$Timer.start()
		Global.worlds.FIRST_LEVEL:
			first_level_array[song_index].play()
			song_index += 1
			if song_index > first_level_array.size() - 1:
				$Timer.stop()
			else:
				$Timer.start()
