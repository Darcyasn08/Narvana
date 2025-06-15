extends CharacterBody3D

var damage := 1

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	pass

func _on_hitbox_area_shape_entered(area_rid: RID, area: Area3D, area_shape_index: int, local_shape_index: int) -> void:
	if area.is_in_group("weapon") or area.is_in_group("player"):
		await activate()
		queue_free()

func activate():
	$CSGBox3D.show() #substituir pela animação dele mordendo
	$CSGBox3D2.show()
	$hurtbox/CollisionShape3D.disabled = false #temp, depois tem que deixar os collision junto com os bone debaixo da terra 
	await(get_tree().create_timer(1).timeout)

func _on_hurtbox_area_entered(area: Area3D) -> void:
	if area.name == "player_hitbox":
		get_tree().call_group("player","hurt",damage)
