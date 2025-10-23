extends Node3D

@export var area_node: Area3D
@export var current_room: int
@export var door: MeshInstance3D

var player_left: bool = false
var is_second_level: bool = false

var spawner_list: Array

var enemy_death_count: int = 0

func _ready() -> void:
	var rooms: int
	var rooms_to_add: int
	await get_tree().create_timer(.1).timeout
	match Global.current_world:
		Global.worlds.FIRST_LEVEL:
			print("is on first level")
			if Global.dead_enemies_first_level.size() <= current_room:
				for room: Array in Global.dead_enemies_first_level:
					rooms += 1
					rooms_to_add = (current_room+1) - rooms
				for i: int in rooms_to_add:
					Global.dead_enemies_first_level.append([0, 0])
			Global.dead_enemies_first_level[current_room][0] = 0
			Global.dead_enemies_first_level[current_room][1] = 0
		Global.worlds.SECOND_LEVEL:
			if Global.dead_enemies_second_level.size() <= current_room:
				for room: Array in Global.dead_enemies_second_level:
					rooms += 1
					rooms_to_add = (current_room+1) - rooms
				for i: int in rooms_to_add:
					Global.dead_enemies_second_level.append([0, 0])
			Global.dead_enemies_second_level[current_room][0] = 0
			Global.dead_enemies_second_level[current_room][1] = 0
			is_second_level = true
			if $StaticBody3D:
				for child in $StaticBody3D.get_children():
					child.set_deferred("disabled", true)
			if $particles:
				for particle in $particles.get_children():
					particle.emitting = false
	area_node.area_entered.connect(_on_area_3d_area_entered)
	area_node.body_entered.connect(_on_area_3d_body_entered)
	area_node.body_exited.connect(_on_area_3d_body_exited)
	if $Area3D:
		$Area3D.set_collision_mask_value(1, false)
		$Area3D.set_collision_mask_value(2, true)
		$Area3D.set_collision_mask_value(3, true)
		$Area3D.add_to_group("spawners")
	await get_tree().create_timer(1).timeout
	
	if area_node:
		area_node.add_to_group("spawners")

func update_enemy_deaths() -> void:
	enemy_death_count += 1
	match Global.current_world:
		Global.worlds.FIRST_LEVEL:
			Global.dead_enemies_first_level[current_room][0] = enemy_death_count
			await get_tree().create_timer(.3).timeout #dá o tempo para caso mais algum inimigo apareça (tipo do porquinho)
			#vê se o valor é maior ou igual ao objetivo global
			print("OBJETIVO DA SALA: ",Global.dead_enemies_first_level[current_room][1], " INIMIGOS DERROTADOS: ", enemy_death_count)
			#print("current enemy deaths: ",enemy_death_count)
			if enemy_death_count >= Global.dead_enemies_first_level[current_room][1]:
				SignalBus.on_room_completed.emit(current_room)
		Global.worlds.SECOND_LEVEL:
			Global.dead_enemies_second_level[current_room][0] = enemy_death_count
			await get_tree().create_timer(.3).timeout
			print("OBJETIVO DA SALA: ",Global.dead_enemies_second_level[current_room][1], " INIMIGOS DERROTADOS: ", enemy_death_count)
			if enemy_death_count >= Global.dead_enemies_second_level[current_room][1]:
				SignalBus.on_room_completed.emit(current_room)
				if $StaticBody3D:
					for child in $StaticBody3D.get_children():
						child.set_deferred("disabled", true)
				if $particles:
					for particle in $particles.get_children():
						particle.emitting = false
		#Global.worlds.THIRD_LEVEL:

func start_room(current_room: int) -> void:
	SignalBus.on_start_room.emit(current_room)
	if is_second_level:
		if $StaticBody3D:
			for child in $StaticBody3D.get_children():
				child.set_deferred("disabled", false)
		if $particles:
			for particle in $particles.get_children():
				particle.emitting = true

func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.name == "player_hitbox":
		if !player_left:
			print("player entered!! and current wave: ",current_room)
			await get_tree().create_timer(.3).timeout
			start_room(current_room)
			if $player_pos_node:
				SignalBus.on_set_player_pos.emit($player_pos_node.global_position, $player_pos_node.global_rotation)

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("enemies"):
		update_enemy_deaths()
	if body.name == "player":
		player_left = true

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemies"):
		match Global.current_world:
			Global.worlds.FIRST_LEVEL:
				Global.dead_enemies_first_level[current_room][1] += 1
			Global.worlds.SECOND_LEVEL:
				print(body.name)
				Global.dead_enemies_second_level[current_room][1] += 1
				print("OBJETIVO DA SALA: ",Global.dead_enemies_second_level[current_room][1], " INIMIGOS DERROTADOS: ", enemy_death_count)
	if body.name == "player":
		pass
