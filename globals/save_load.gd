extends Node

#https://www.youtube.com/watch?v=xG2GGniUa5o
var save_path = "user://narvana_save.json"

var save_content: Dictionary = {
	"health": Global.player_health,
	"has_started_game": Global.has_started_game,
	"current_world": Global.current_world,
	"inventory": Global.inventory,
}

func _ready() -> void:
	load_save()
	if save_content.has_started_game:
		print("game has started!")
	else:
		print("game hasnt started yet... show start cutscene")

func save():
	var file = FileAccess.open_encrypted_with_pass(save_path, FileAccess.WRITE, "narval")
	file.store_var(save_content.duplicate())
	file.close()

func load_save():
	if FileAccess.file_exists(save_path):
		#print("save exists")
		var file = FileAccess.open_encrypted_with_pass(save_path, FileAccess.READ, "narval")
		var data = file.get_var()
		file.close()
		
		var save_data = data.duplicate()
		#print("save: ",save_data)
		#save_content.n = save_data.n
		save_content.health = save_data.health
		for i in save_data:
			pass

func delete_save():
	if FileAccess.file_exists(save_path):
		save_content.todo_list = {}
		print(save_content.todo_list)
		save()
