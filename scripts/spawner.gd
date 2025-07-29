extends Node3D

@export var level_number: int
@export var enemy_number: int
@export var room_number: int

@onready var catch_enemy: String = Global.enemies[level_number][enemy_number]
@onready var enemy_path: Object = load(catch_enemy)

func _ready() -> void:
	SignalBus.on_start_room.connect(spawn_enemies)
	$Label3D.hide()
	$MeshInstance3D.hide()

func _process(delta: float) -> void:
	pass

func spawn_enemies(room) -> void:
	if room == room_number:
		var enemy: Object = enemy_path.instantiate()
		
		#substitui global_position por transform.origin, pra não aparecer um sinal de erro
		#talvez precisemos fazer isso em outras partes também
		enemy.transform.origin = global_position 
		get_parent().add_child(enemy)
		await get_tree().create_timer(2).timeout
		queue_free()
