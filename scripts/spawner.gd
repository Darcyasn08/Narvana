extends Node3D

@export var level_number: int
@export var enemy_number: int
@export var wave_number: int

@onready var catch_enemy = Global.enemies[level_number][enemy_number]
@onready var enemy_path = load(catch_enemy)

func _ready() -> void:
	pass
	#SignalBus.on_start_wave.connect(spawn_enemies)
	#SignalBus.on_first_level_entered.connect(spawn_enemies)

func _process(delta: float) -> void:
	pass

#func spawn_enemies(area_name, current_wave):
	#if area_name == name and wave_number == current_wave:
		#print("ignited: ",area_name, " wave: ",current_wave)
		#var enemy = enemy_path.instantiate()
		#enemy.global_position = global_position
		#get_parent().add_child(enemy)
		#await get_tree().create_timer(2).timeout
		#queue_free()

func spawn_enemies():
	var enemy = enemy_path.instantiate()
	enemy.global_position = global_position
	get_parent().add_child(enemy)
	await get_tree().create_timer(2).timeout
	queue_free()

func _on_detection_area_entered(area: Area3D) -> void:
	spawn_enemies()
	#print("area entered aofjeoiafjaidfvjdsi")
	#if area.is_in_group("weapon"):
		#var enemy = enemy_path.instantiate()
		#enemy.global_position = global_position
		#get_parent().add_child(enemy)
		#queue_free()
