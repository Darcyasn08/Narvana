extends CharacterBody3D

var life: int = 700
var damage: int = 1
var bullet_speed: float = 20.0
var level: int = 2
var state: String = "dragons"
var speed: float = 10.0

var dragonins: Object = preload("res://scenes/enemies/pearl_collar.tscn")
var pearlins: Object = preload("res://scenes/projectile.tscn")
var blushins: int = 1

@onready var player = $"../player"


func _ready() -> void:
	$Timer.start()


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	if state != "teleporting":
		look_to_player(delta)
	move_and_slide()

func damage_player(area)-> void:
	pass

func knockback(force: Vector3, impact_point: Vector3)-> void:
	velocity = force.limit_length(15.0)


func calculate_knockback(area: Area3D)-> void:
	var body_collision = (global_position - area.global_position)
	body_collision.y = 0.0
	var force = body_collision
	knockback(force, body_collision)
	await(get_tree().create_timer(.3).timeout)
	velocity = velocity * 0

func unique_take_damage(area)-> void:
	calculate_knockback(area)
	
func unique_die()-> void:
	pass

func look_to_player(delta : float)-> void:
	var pos2d: Vector2 = Vector2(global_position.x, global_position.z)
	var targetpos2d: Vector2 = Vector2(player.global_position.x, player.global_position.z)
	var target_angle = pos2d - targetpos2d
	global_rotation.y = lerp_angle(rotation.y,atan2(target_angle.x, target_angle.y), delta * 1.5)

func shoot() -> void:
	var pearl = pearlins.instantiate()
	pearl.pos = $shoot.global_position
	pearl.rot = rotation
	pearl.follow = false
	pearl.speed = bullet_speed
	pearl.damage = damage
	#futuramente determinar o molde do projetil
	if state == "blush":
		pearl.blush = true
	get_parent().add_child(pearl)


func _on_timer_timeout() -> void:
	if state != "blush":
		shoot()
		await(get_tree().create_timer(3).timeout)
		shoot()
		await(get_tree().create_timer(3).timeout)
	if state == "blush":
		shoot()
		await(get_tree().create_timer(1).timeout)
		shoot()
		await(get_tree().create_timer(1).timeout)
		shoot()
		await teleporting()
		state = "shooting"
		$Timer.wait_time = 2
		$Timer.start()
	elif state == "dragons":
		var dragon1 = dragonins.instantiate()
		dragon1.global_rotation = $invocation_point1.global_rotation
		dragon1.global_position = $invocation_point1.global_position
		var dragon2 = dragonins.instantiate()
		dragon2.global_rotation = $invocation_point2.global_rotation
		dragon2.global_position = $invocation_point2.global_position
		get_parent().add_child(dragon1)
		get_parent().add_child(dragon2)
		if level >= 2:
			state = "blush"
		else : 
			state = "shooting"
		await(get_tree().create_timer(1).timeout)
		await teleporting()
		$Timer.wait_time = 2
		$Timer.start()
	elif state == "shooting":
			shoot()
			state = "dragons"
			await teleporting()
			$Timer.wait_time = 2
			$Timer.start()
			

func teleporting2() -> void:
	var old_rotation = rotation.y
	var old_state = state
	state = "teleporting"
	hide()
	set_collision_mask_value(2, false)
	set_collision_mask_value(3, false)
	$enemy_hitbox/hitbox.disabled = true
	rotation.y = deg_to_rad(float(randi_range(-180,180)))
	var random = randi_range(1,4)
	var forward := global_basis.z #determina oq é a frente 
	forward = forward.normalized()
	velocity = velocity.move_toward(forward * -speed, 20000 )
	await(get_tree().create_timer(random).timeout)
	set_collision_mask_value(2, true)
	set_collision_mask_value(3, true)
	$enemy_hitbox/hitbox.disabled = false
	velocity = velocity * 0
	state = old_state
	rotation.y = old_rotation
	show()


func teleporting() -> void:
	var old_rotation = rotation.y
	#var old_state = state
	#state = "tenna"
	$teleport.rotation.y = deg_to_rad(float(randi_range(-180,180)))
	#print(rad_to_deg($tele_pilot.rotation.y))
	if $teleport.get_collider() != null:
		var limit = $teleport.get_collision_point()
		print("------")
		print("limit is: ",limit)
		print("prev global pos: ",global_position)
		#print($tele_pilot/teleport.global_position.z)
		
		var rand_posz = check_pos_difference(limit)
		if rand_posz == null:
			teleporting()
			return
		
		if rad_to_deg($teleport.rotation.y) < -90 or rad_to_deg($teleport.rotation.y) > 90:
			print("first one")
			#global_rotation.y = $RayCast3D.rotation.y
			#rand_posz = (rand_posz)
		else:
			print("second one")
			#rand_posz = randf_range(global_position.z, limit.z - 3)
			#global_rotation.y = $RayCast3D.rotation.y
		await(get_tree().create_timer(1).timeout)
		#print("aaa ", global_position.z, "aaaa ",rand_posz)
		var mult = abs(abs(global_position.z)-abs(rand_posz))/global_basis.z.z
		#print("mult: ",mult, " --- distance: ", abs(global_position.z-rand_posz), "/global_basis.z.z: ",global_basis.z.z)
		#print("diff pos: ",(rand_posz-global_position.z))
		global_position = ($teleport.global_basis.z * mult) + global_position
		#print("global_basis: ",global_basis.z)
		#print("rand_posz: ",rand_posz)
		#print("current_global_pos: ",global_position)
		#print("------")
		rotation.y = old_rotation
	
	else:
		var limit = $teleport.get_collision_point()
		#print($tele_pilot/teleport.global_position.z)
		var rand_posz = randf_range($teleport.position.z + 2,limit.z + 20)
		if rad_to_deg($teleport.rotation.y) < -90 or rad_to_deg($teleport.rotation.y) > 90:
			global_rotation.y = $teleport.rotation.y
			print(rand_posz)
			rand_posz = -(rand_posz)
			print(rand_posz)
		else:
			global_rotation.y = $teleport.rotation.y
			await(get_tree().create_timer(1).timeout)
			var mult = rand_posz/global_basis.z.z
			global_position = ($teleport.global_basis.z * mult) + global_position
			print(global_position)
			rotation.y = old_rotation

func check_pos_difference(limit):
#tenta 10 vezes algum valor que seja pelo menos 2 metros longe do player
	for i in 10:
		var rand_posz = randf_range(global_position.z, limit.z)
		if abs(abs(rand_posz)-abs(global_position.z)) > 2:
			print("diferente!!!!")
			print("rand: ",rand_posz)
			return rand_posz
		#else:
			#print("não é diferente...")
	var rand_posz = randf_range(global_position.z, limit.z)
	#se depois das 10 tentivas, ainda não der certo..
	if abs(abs(rand_posz)-abs(global_position.z)) < 2:
		pass #...fazer algo pra recalcular a rotação
