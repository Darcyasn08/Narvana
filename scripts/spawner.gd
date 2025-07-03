extends Node3D

@export var level_number: int
@export var enemy_number: int
@export var room_number: int

@onready var catch_enemy = Global.enemies[level_number][enemy_number]
@onready var enemy_path = load(catch_enemy)

func _ready() -> void:
	pass
	SignalBus.on_start_room.connect(spawn_enemies)

func _process(delta: float) -> void:
	pass

func spawn_enemies(room):
	if room == room_number:
		var enemy = enemy_path.instantiate()
		
		#substitui global_position por transform.origin, pra não aparecer um sinal de erro
		#talvez precisemos fazer isso em outras partes também
		enemy.transform.origin = global_position 
		get_parent().add_child(enemy)
		await get_tree().create_timer(2).timeout
		queue_free()
