extends Node3D

@export var level_number: int
@export var enemy_number: int

@onready var catch_enemy = Global.enemies[level_number][enemy_number]
@onready var enemy_path = load(catch_enemy)

func _ready() -> void:
	SignalBus.on_first_level_entered.connect(spawn_enemies)

func _process(delta: float) -> void:
	pass

func spawn_enemies():
	#var catch_enemy = Global.enemies[level_number][enemy_number]
	#var enemy_path = load(catch_enemy)
	
	var enemy = enemy_path.instantiate()
	enemy.global_position = global_position
	get_parent().add_child(enemy)
	queue_free()

func _on_detection_area_entered(area: Area3D) -> void:
	pass
	#if area.is_in_group("weapon"):
		#var enemy = enemy_path.instantiate()
		#enemy.global_position = global_position
		#get_parent().add_child(enemy)
		#queue_free()
