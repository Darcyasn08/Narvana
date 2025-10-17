extends Node3D

var speed : float = 0.2
var time : float
var falling : bool
var damage : int
var pos : Vector3

func _ready() -> void:
	global_position = pos
	await(get_tree().create_timer(time).timeout)
	falling = true

func _physics_process(delta: float) -> void:
	if falling:
		$falling_obj.position.y -= speed

func _on_floor_area_entered(area: Area3D) -> void:
	if area.name == "falling_obj":
		queue_free()


func _on_falling_obj_area_entered(area: Area3D) -> void:
	if area.name == "player_hitbox":
		get_tree().call_group("player","hurt",damage)
