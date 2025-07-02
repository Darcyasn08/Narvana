extends CharacterBody3D

var damage := 1

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	pass

func _on_hitbox_area_entered(area: Area3D) -> void:
	if area.is_in_group("weapon") or area.is_in_group("player"):
		await activate()
		queue_free()

func activate():
	print("activate")
	$CSGBox3D.show() #substituir pela animação dele mordendo
	$CSGBox3D2.show()
	$hurtbox.monitoring = true #temp, depois tem que deixar os collision junto com os bone debaixo da terra 
	await(get_tree().create_timer(3).timeout)

func _on_hurtbox_area_entered(area: Area3D) -> void:
	print("area entered!!!")
	print($hurtbox/CollisionShape3D.disabled)
	if area.name == "player_hitbox":
		print("dude")
		get_tree().call_group("player","hurt",damage)


func _on_timer_timeout() -> void:
	#$hurtbox/CollisionShape3D.disabled = true
	print("timer off")
