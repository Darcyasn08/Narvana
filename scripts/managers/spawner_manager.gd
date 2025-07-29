extends Node3D

@export var area_node: Area3D
@export var current_room: int
@export var door: MeshInstance3D

var player_left: bool = false

var spawner_list: Array

var enemy_death_count: int = 0

func _ready() -> void:
	var rooms: int
	var rooms_to_add: int
	if Global.dead_enemies_first_level.size() <= current_room:
		for room in Global.dead_enemies_first_level:
			rooms += 1
			rooms_to_add = (current_room+1) - rooms
			#print("rooms to add: ",rooms_to_add)
		for i in rooms_to_add:
			Global.dead_enemies_first_level.append([0, 0])
	#print(Global.dead_enemies_first_level)
	await get_tree().create_timer(1).timeout
	area_node.area_entered.connect(_on_area_3d_area_entered)
	area_node.body_entered.connect(_on_area_3d_body_entered)
	area_node.body_exited.connect(_on_area_3d_body_exited)
	#print(current_room, " ",Global.dead_enemies_first_level)
	Global.dead_enemies_first_level[current_room][0] = 0
	Global.dead_enemies_first_level[current_room][1] = 0

func update_enemy_deaths():
	enemy_death_count += 1
	Global.dead_enemies_first_level[current_room][0] = enemy_death_count
	#print("current enemy deaths: ",enemy_death_count)
	
	await get_tree().create_timer(.3).timeout #dá o tempo para caso mais algum inimigo apareça (tipo do porquinho)
	#vê se o valor é maior ou igual ao objetivo global
	print("OBJETIVO DA SALA: ",Global.dead_enemies_first_level[current_room][1], " INIMIGOS DERROTADOS: ", enemy_death_count)
	if enemy_death_count >= Global.dead_enemies_first_level[current_room][1]:
		SignalBus.on_room_completed.emit(current_room)

func start_room(current_room):
	SignalBus.on_start_room.emit(current_room)

func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.name == "player_hitbox":
		if !player_left:
			print("player entered!! and current wave: ",current_room)
			await get_tree().create_timer(.4).timeout
			start_room(current_room)

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("enemies"):
		update_enemy_deaths()
	if body.name == "player":
		player_left = true

func _on_area_3d_body_entered(body: Node3D) -> void:
	print("boddy entered")
	if body.is_in_group("enemies"):
		Global.dead_enemies_first_level[current_room][1] += 1
		print("OBJETIVO DA SALA: ",Global.dead_enemies_first_level[current_room][1], " INIMIGOS DERROTADOS: ", enemy_death_count)
	if body.name == "player":
		pass
