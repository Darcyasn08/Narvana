extends Node3D

@export var level_number: int
@export var enemy_number: int
@export var room_number: int

@onready var catch_enemy = Global.enemies[level_number][enemy_number]
@onready var enemy_path = load(catch_enemy)

func _ready() -> void:
	pass
	SignalBus.on_start_room.connect(spawn_enemies)
	#SignalBus.on_first_level_entered.connect(spawn_enemies)

func _process(delta: float) -> void:
	pass

func spawn_enemies(room):
	#if area_name == name:
	#print("AAAAAAAAAAAAA")
	#print("wave received: ",room)
	if room == room_number:
		print("activated")
		var enemy = enemy_path.instantiate()
		enemy.global_position = global_position
		get_parent().add_child(enemy)
		await get_tree().create_timer(2).timeout
		queue_free()

func _on_detection_area_entered(area: Area3D) -> void:
	pass
	#spawn_enemies()
	#print("area entered aofjeoiafjaidfvjdsi")
	#if area.is_in_group("weapon"):
		#var enemy = enemy_path.instantiate()
		#enemy.global_position = global_position
		#get_parent().add_child(enemy)
		#queue_free()
