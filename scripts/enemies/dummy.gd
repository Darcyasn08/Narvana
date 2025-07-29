extends Node3D

var health: int = 3

func _ready() -> void:
	$CharacterBody3D/CollisionShape3D.disabled = true
	await get_tree().create_timer(1).timeout
	$CharacterBody3D/CollisionShape3D.disabled = false
	await get_tree().create_timer(2).timeout

func _on_area_3d_area_entered(area: Area3D) -> void:
	#print("area entered!!", area.name)
	if area.is_in_group("weapon"):
		#print(":0")
		health -= 1
		$damage_label.show()
		await get_tree().create_timer(.6).timeout
		$damage_label.hide()
		if health <= 0:
			queue_free()
