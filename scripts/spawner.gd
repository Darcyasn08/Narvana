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

func spawn_enemies(room: int) -> void:
	if room == room_number:
		var enemy: Object = enemy_path.instantiate()
		#substitui global_position por transform.origin, pra não aparecer um sinal de erro
		#talvez precisemos fazer isso em outras partes também
		$summon_particle.emitting = true
		await get_tree().create_timer(1).timeout
		enemy.transform.origin = global_position 
		get_parent().add_child(enemy)
		await get_tree().create_timer(.1).timeout
		$summon_particle.emitting = false
		await get_tree().create_timer(1.5).timeout
		queue_free()

func _on_detection_area_entered(area: Area3D) -> void:
	#detectar o spawner manager e automaticamente colocar o número da sala em si mesmo
	if "spawner_manager" in area.get_parent().name:
		room_number = area.get_parent().current_room
