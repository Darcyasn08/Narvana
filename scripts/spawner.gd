extends Node3D

@onready var fase = int(round(rad_to_deg(rotation.x)))
@onready var inimigo = int(round(rad_to_deg(rotation.y)))
@onready var catch_enemy = Global.enemys[fase][inimigo]
@onready var enemy_path = load(catch_enemy)

func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_detection_area_shape_entered(area_rid: RID, area: Area3D, area_shape_index: int, local_shape_index: int) -> void:
	if area.is_in_group("weapon"):
		var enemy = enemy_path.instantiate()
		enemy.global_position = global_position
		get_parent().add_child(enemy)
		queue_free()
