extends Node3D

@export var area_node: Area3D
@export var current_room: int
@export var door: MeshInstance3D

var player_left: bool = false

var spawner_list: Array

var enemy_death_count: int = 0

func _ready() -> void:
	print("ROOM NUMBER: ", current_room)
	SignalBus.on_room_completed.connect(start_room)
	#SignalBus.on_enemy_death.connect(update_enemy_deaths)

func update_enemy_deaths():
	enemy_death_count += 1
	Global.dead_enemies_first_level[current_room][0] = enemy_death_count
	print("current enemy deaths: ",enemy_death_count)
	
	#vê se o valor é maior ou igual ao objetivo global
	if enemy_death_count >= Global.dead_enemies_first_level[current_room][1]:
		Global.current_wave += 1
		SignalBus.on_room_completed.emit(current_room)
		#print("heyyy")

func start_room():
	#print("wave emmited: ",current_room)
	SignalBus.on_start_room.emit(current_room)

func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.is_in_group("spawners"):
		area.monitorable = true
		var area_n = area.get_parent().name
		spawner_list.append(area_n)

	if area.name == "player_hitbox":
		if !player_left:
			print("OBJETIVO DA SALA: ",Global.dead_enemies_first_level[current_room][1])
			#print("player entered!! and current wave: ",current_room)
			await get_tree().create_timer(.4).timeout
			start_room()

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("enemies"):
		update_enemy_deaths()
	if body.name == "player":
		player_left = true

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "player":
		pass
