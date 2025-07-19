extends Node3D

func _ready() -> void:
	Global.current_world = Global.worlds.SECOND_LEVEL

func _physics_process(delta: float) -> void:
	pass

func _on_timer_timeout() -> void:
	#if $CharacterBody3D/RayCast3D.get_collider() != null:
		#print("player: ",$player.global_position)
		#print("ray cast: ",$CharacterBody3D/RayCast3D.global_position)
		#print("diff: ",$player.global_position.x-$CharacterBody3D/RayCast3D.global_position.x)
		#var rand_posx = randf_range($CharacterBody3D/RayCast3D.global_position.x,$player.global_position.x)
		#var rand_pos = randf_range($CharacterBody3D/RayCast3D.global_position.z,$player.global_position.z)
		#print("rand pos... x: ",rand_posx, " --- z:", rand_pos)
		#$indicator.position.x = rand_posx
		#$indicator.position.z = rand_pos
		
	var old_rotation = $CharacterBody3D.rotation.y
	#var old_state = state
	#state = "tenna"
	$CharacterBody3D/RayCast3D.rotation.y = deg_to_rad(float(randi_range(-180,180)))
	#print(rad_to_deg($tele_pilot.rotation.y))
	await(get_tree().create_timer(1).timeout)
	if $CharacterBody3D/RayCast3D.get_collider() != null:
		var limit = $CharacterBody3D/RayCast3D.get_collision_point()
		#print($tele_pilot/teleport.global_position.z)
		var rand_posz
		if rad_to_deg($CharacterBody3D/RayCast3D.rotation.y) < -90 or rad_to_deg($CharacterBody3D/RayCast3D.rotation.y) > 90:
			rand_posz = randf_range(position.z - 2,limit.z + 1)
			global_rotation.y = $CharacterBody3D/RayCast3D.rotation.y
			rand_posz = -(rand_posz)
		else:
			rand_posz = randf_range(position.z + 2,limit.z - 1)
			global_rotation.y = $CharacterBody3D/RayCast3D.rotation.y
			await(get_tree().create_timer(1).timeout)
			var mult = rand_posz/global_basis.z.z
			global_position = (global_basis.z * mult) + global_position
			print(global_position)
			rotation.y = old_rotation

	else:
		var limit = $CharacterBody3D/RayCast3D.get_collision_point()
		#print($tele_pilot/teleport.global_position.z)
		var rand_posz = randf_range($CharacterBody3D/RayCast3D.position.z + 2,limit.z + 20)
		if rad_to_deg($CharacterBody3D/RayCast3D.rotation.y) < -90 or rad_to_deg($CharacterBody3D/RayCast3D.rotation.y) > 90:
			global_rotation.y = $CharacterBody3D/RayCast3D.rotation.y
			print(rand_posz)
			rand_posz = -(rand_posz)
			print(rand_posz)
		else:
			global_rotation.y = $CharacterBody3D/RayCast3D.rotation.y
			await(get_tree().create_timer(1).timeout)
			var mult = rand_posz/global_basis.z.z
			global_position = (global_basis.z * mult) + global_position
			print(global_position)
			rotation.y = old_rotation
	#state = old_state
