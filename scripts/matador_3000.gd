extends Area3D
var damage := 1
@onready var player = $"../player"
var life := 500

func _physics_process(delta: float) -> void:
	look_at(player.global_position)

func _on_area_shape_entered(area_rid: RID, area: Area3D, area_shape_index: int, local_shape_index: int) -> void:
	if area.name == "player_hitbox":
		get_tree().call_group("player","hurt",damage)
		
	if area.is_in_group("weapon"):
		if life > Global.player_damage :
			life -= Global.player_damage
			#print(life)
		else:
			queue_free()
		
