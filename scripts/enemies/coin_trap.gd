extends CharacterBody3D

var damage : int = 1

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	pass

func _on_hitbox_area_entered(area: Area3D) -> void:
	if area.is_in_group("weapon") or area.is_in_group("player"):
		await activate()
		queue_free()

func activate() -> void:
	#print("activate")
	$head_top.show()
	$head_bottom.show()
	$headless_body.show()
	$hurtbox.monitoring = true #temp, depois tem que deixar os collision junto com os bone debaixo da terra 
	await(get_tree().create_timer(2.5).timeout)

func _on_hurtbox_area_entered(area: Area3D) -> void:
	print("area entered!!!")
	if area.name == "player_hitbox":
		get_tree().call_group("player","hurt",damage)

func _on_timer_timeout() -> void:
	pass
	#$hurtbox/CollisionShape3D.disabled = true
