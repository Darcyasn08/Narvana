extends CharacterBody3D

func _ready() -> void:
	#await get_tree().create_timer(1).timeout
	#var mult = 10/global_basis.z.z
	#global_position = (global_basis.z * mult) + global_position
	#teleport()
	$Timer.start()

func teleport() -> void:
	var old_rotation = rotation.y
	#var old_state = state
	#state = "tenna"
	$RayCast3D.rotation.y = deg_to_rad(float(randi_range(-180,180)))
	#print(rad_to_deg($tele_pilot.rotation.y))
	if $RayCast3D.get_collider() != null:
		var limit = $RayCast3D.get_collision_point()
		print("------")
		print("limit is: ",limit)
		print("prev global pos: ",global_position)
		#print($tele_pilot/teleport.global_position.z)
		
		
		
		
		var rand_posz = check_pos_difference(limit)
		print(rand_posz)
		
		if rad_to_deg($RayCast3D.rotation.y) < -90 or rad_to_deg($RayCast3D.rotation.y) > 90:
			print("first one")
			#global_rotation.y = $RayCast3D.rotation.y
			#rand_posz = (rand_posz)
		else:
			print("second one")
			#rand_posz = randf_range(global_position.z, limit.z - 3)
			#global_rotation.y = $RayCast3D.rotation.y
		await(get_tree().create_timer(1).timeout)
		print("aaa ", global_position.z, "aaaa ",rand_posz)
		var mult = abs(abs(global_position.z)-abs(rand_posz))/global_basis.z.z
		print("mult: ",mult, " --- distance: ", abs(global_position.z-rand_posz), "/global_basis.z.z: ",global_basis.z.z)
		print("diff pos: ",(rand_posz-global_position.z))
		global_position = ($RayCast3D.global_basis.z * mult) + global_position
		print("global_basis: ",global_basis.z)
		print("rand_posz: ",rand_posz)
		print("current_global_pos: ",global_position)
		print("------")
		rotation.y = old_rotation
	
	else:
		var limit = $RayCast3D.get_collision_point()
		#print($tele_pilot/teleport.global_position.z)
		var rand_posz = randf_range($RayCast3D.position.z + 2,limit.z + 20)
		if rad_to_deg($RayCast3D.rotation.y) < -90 or rad_to_deg($RayCast3D.rotation.y) > 90:
			global_rotation.y = $RayCast3D.rotation.y
			print(rand_posz)
			rand_posz = -(rand_posz)
			print(rand_posz)
		else:
			global_rotation.y = $RayCast3D.rotation.y
			await(get_tree().create_timer(1).timeout)
			var mult = rand_posz/global_basis.z.z
			global_position = ($RayCast3D.global_basis.z * mult) + global_position
			print(global_position)
			rotation.y = old_rotation

func check_pos_difference(limit):
	for i in 10:
		var rand_posz = randf_range(global_position.z, limit.z)
		if abs(abs(rand_posz)-abs(global_position.z)) > 2:
			print("diferente!!!!")
			print("rand: ",rand_posz)
			return rand_posz
		else:
			print("não é diferente...")
	
	#se depois das 10 tentivas, ainda não der certo..
	if abs(abs(1)-abs(global_position.z)) < 2:
		pass #...fazer algo pra recalcular a rotação

func _on_timer_timeout() -> void:
	teleport()
