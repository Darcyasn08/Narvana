extends Node3D

@export var area_node: Area3D
@export var current_wave: int

var enemy_death_count: int = 0

func _ready() -> void:
	pass
	#SignalBus.on_enemy_death.connect(update_enemy_deaths)

func update_enemy_deaths():
	enemy_death_count += 1
	Global.dead_enemies_first_level[current_wave][0] = enemy_death_count
	if enemy_death_count == Global.dead_enemies_first_level[0][1]:
		$"../separation_wall".queue_free()
		$"../platform2".show()
		print("heyyy")

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("enemies"):
		update_enemy_deaths()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "player":
		pass
