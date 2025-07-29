extends Node

#https://www.youtube.com/watch?v=xG2GGniUa5o
var save_path: String = "user://narvana_save.json"

var save_content: Dictionary = {
	"health": Global.player_health,
	"has_started_game": Global.has_started_game,
	"current_world": Global.current_world,
	"inventory": Global.inventory,
}

func _ready() -> void:
	delete_save()
	load_save()
	if save_content.has_started_game:
		print("game has started!")
	else:
		print("game hasnt started yet... show start cutscene")

func save() -> void:
	var file = FileAccess.open_encrypted_with_pass(save_path, FileAccess.WRITE, "narval")
	file.store_var(save_content.duplicate())
	file.close()
	print("jogo salvo!")

func load_save() -> void:
	if FileAccess.file_exists(save_path):
		#print("save exists")
		var file = FileAccess.open_encrypted_with_pass(save_path, FileAccess.READ, "narval")
		var data = file.get_var()
		file.close()
		
		var save_data = data.duplicate()
		
		save_content.health = save_data.health
		Global.player_health = save_content.health
		save_content.current_world = save_data.current_world
		save_content.inventory = save_data.inventory
		Global.inventory = save_content.inventory
		print(save_data.inventory)
		for i in save_data:
			pass

func delete_save() -> void:
	if FileAccess.file_exists(save_path):
		DirAccess.remove_absolute(save_path)
		save_content.current_world = Global.current_world
		save_content.health = Global.player_health
		save_content.inventory = Global.inventory
		Global.has_started_game = false
		save_content.has_started_game = Global.has_started_game
		save()
