extends Node3D

@export var area_node: Area3D
@export var current_wave: int

var spawner_list: Array

var enemy_death_count: int = 0

func _ready() -> void:
	SignalBus.on_wave_completed.connect(start_wave)
	#SignalBus.on_enemy_death.connect(update_enemy_deaths)

func update_enemy_deaths():
	enemy_death_count += 1
	Global.dead_enemies_first_level[current_wave][0] = enemy_death_count
	if enemy_death_count == Global.dead_enemies_first_level[0][1]:
		$"../separation_wall".queue_free()
		$"../platform2".show()
		Global.current_wave += 1
		print("heyyy")

func start_wave():
	for spawner in spawner_list:
		SignalBus.on_start_wave.emit(spawner, Global.current_wave)

func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.is_in_group("spawners"):
		area.monitorable = true
		#var area_n = area.get_parent().name
		#spawner_list.append(area_n)

	if area.name == "player_hitbox":
		print("player entered!!")
		#await get_tree().create_timer(.4).timeout
		#start_wave()

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("enemies"):
		update_enemy_deaths()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "player":
		pass
