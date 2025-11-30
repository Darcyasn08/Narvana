extends Node3D

var speed : float = 0.2
var time : float
var falling : bool
var damage : int
var pos : Vector3
var molde: String = ""
var escale: Vector3

func _ready() -> void:
	if molde != "":
		$falling_obj/molde.hide()
		var projectile_inst: Object = load(molde)
		var projectile: Object = projectile_inst.instantiate()
		projectile.scale = escale
		$falling_obj.add_child(projectile)
	position = pos
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
