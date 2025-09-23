extends CharacterBody3D

# VARIÁVEIS EM REAÇÃO A MOVIMENTAÇÃO
var JUMP_VELOCITY: float = 4
var camera_input_direction := Vector2.ZERO
var last_movement_direction := Vector3.BACK
var mouse_sens: float = .11
var move_speed: float = 8.0
var acceleration: float = 15.0
var rotation_speed: float = 10.0
var jump_impulse: float = 12.0
var gravity: float = -30.0
var ground_speed: float
var magic_selec : int = 1 #temporario

# OUTRAS VARIÁVEIS (depois eu separo isso melhor)
var health: int = 6
var dashed: bool = false
var knockbacked: bool = false
var stunned: bool = false
var immune: bool = false
var immune_time: float = 2.5

# VARIÁVEIS DE IMPRTAÇÃO
@onready var camera_pivot: Node3D = $camera_pivot
@onready var camera: Camera3D = $camera_pivot/SpringArm3D/Camera3D
@onready var skin: Node3D = $narwhal_skin
@onready var death_screen_inst: Object = preload("res://scenes/UI/death_screen.tscn")


func _ready() -> void:
	#Global.current_weapon = 1
	print("current_weapon: ",Global.current_weapon)
	SignalBus.on_changed_mouse_sens.connect(change_mouse_sens)
	SignalBus.on_change_player_weapon.connect(change_current_weapon)
	change_current_weapon(Global.current_weapon)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	health = Global.player_health
	SignalBus.on_player_health_changed.emit(health)
	await get_tree().create_timer(2).timeout

func _physics_process(delta: float) -> void:
	if $narwhal_skin/narval_model/Armature_002/Skeleton3D/bat/Area3D.monitorable:
		$MeshInstance3D.mesh.size.y = 1
	else:
		$MeshInstance3D.mesh.size.y = .2
	#se o player cair, ele pelo menos volta pra plataforma (vou arrumar isso depois)
	if position.y < -50:
		position = Global.player_base_pos
	
	# MOVIMENTO DA CÂMERA
	camera_pivot.rotation.x += camera_input_direction.y * delta
	camera_pivot.rotation.x = clamp(camera_pivot.rotation.x, -PI/6, PI/4) #limitar a rotação
	camera_pivot.rotation.y += -camera_input_direction.x * delta
	
	camera_input_direction = Vector2.ZERO #a cada frame resetar, pra não rodar pra sempre
	
	if Global.player_can_move:
		var raw_input := Input.get_vector("a", "d", "w", "s")
		var forward := camera.global_basis.z
		var right := camera.global_basis.x
		
		var move_direction := (forward * raw_input.y + right * raw_input.x)*delta #combina os valores de x e z
		move_direction.y = 0.0 #reseta o de y, pq ele não muda na hora de mover
		move_direction = move_direction.normalized()
	
		if move_direction.length() > 0.1:
			last_movement_direction = move_direction
		
		var target_angle := Vector3.BACK.signed_angle_to(last_movement_direction, Vector3.UP)
		skin.global_rotation.y = lerp_angle(skin.rotation.y,target_angle,rotation_speed *delta)
		$CollisionShape3D.global_rotation.y = lerp_angle($CollisionShape3D.global_rotation.y,target_angle,rotation_speed *delta)
		$player_hitbox.global_rotation.y = lerp_angle($player_hitbox.global_rotation.y,target_angle,rotation_speed *delta)
		
		ground_speed = velocity.length()
		if ground_speed > 0.0:
			$narwhal_skin/narval_model/AnimationPlayer.play("walk")
		elif ground_speed <= 0.0:
			$narwhal_skin/narval_model/AnimationPlayer.play("narwhal_idle")
		
		if !knockbacked:
			var y_velocity: float = velocity.y
			velocity.y = 0.0
			velocity = velocity.move_toward(move_direction * move_speed, acceleration * delta)
			velocity.y = y_velocity + gravity * delta
	else:
		ground_speed = 0
		velocity = Vector3(0,0,0)
		#print("velocity: ", velocity, "... ground_speed: ", ground_speed)
		#print("you cant just move mate")

	var is_starting_jump := Input.is_action_pressed("space") and is_on_floor() and stunned == false
	if is_starting_jump:
		velocity.y += jump_impulse
	
	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	var is_camera_motion := (
		event is InputEventMouseMotion and
		Input.mouse_mode == Input.MOUSE_MODE_CAPTURED
	)
	if is_camera_motion:
		camera_input_direction = event.relative * mouse_sens


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack") and Global.player_can_attack:
		attack()
	
	#if event.is_action_pressed("left_click"):
		#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if event.is_action_pressed("e"):
		var actual_target
		var target = $narwhal_skin/RayCast3D.get_collider()
		var target2 = $narwhal_skin/RayCast3D2.get_collider()
		var target3 = $narwhal_skin/RayCast3D3.get_collider()
		if target != null:
			actual_target = target
		if target2 != null:
			actual_target = target2
		if target3 != null:
			actual_target = target3
		if actual_target != null and actual_target.is_in_group("item_throwers"):
			print("its an item_thrower!!")
			#Global.player_can_move = false
			#Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			#$"player_hud/item_thrower_menu".show()
	
	if event.is_action_pressed("r"):
		magic()
	
	if event.is_action_pressed("shift") and dashed == false and is_on_floor(): #tem o is on floor pra nao dar dash no ar
		dash()
		$narwhal_skin/dash_bubble_particle.emitting = true
		await get_tree().create_timer(2).timeout
		$narwhal_skin/dash_bubble_particle.emitting = false
	#para o ataque
	#if event.is_action_pressed("e") and Global.player_can_attack:
		#attack()


func hurt(damage) -> void:
	if damage < Global.player_health and immune == false:
		get_immune(immune_time)
		#muda a cor da skin do narval
		#health -= damage
		Global.player_health -= damage
		health = Global.player_health
		print("player health: ",Global.player_health)
		SignalBus.on_player_health_changed.emit(Global.player_health)
	elif damage >= health and immune == false:
		health = 0
	if health == 0:
		SignalBus.on_player_health_changed.emit(health)
		die()


# próxima atualização: fazer tela de morte
func die() -> void:
	print("morreu")
	get_tree().paused = true
	var death_screen: Object = death_screen_inst.instantiate()
	add_child(death_screen)

func dash() -> void:
	dashed = true
	move_speed += 300
	acceleration += 300
	await(get_tree().create_timer(.05).timeout)
	move_speed -= 300
	acceleration -= 300
	await(get_tree().create_timer(1).timeout)
	dashed = false


func knockback(force: Vector3, _impact_point: Vector3) -> void:
	velocity = force.limit_length(15.0)

func change_current_weapon(weapon: int):
	print("received weapon: ",weapon)
	match weapon:
		Global.weapons.NONE:
			Global.current_weapon == Global.weapons.NONE
			$narwhal_skin/narval_model/Armature_001.hide()
			$narwhal_skin/narval_model/Armature_002.hide()
			$narwhal_skin/narval_model/Armature_003.show()
		Global.weapons.BAT:
			Global.current_weapon == 1
			$narwhal_skin/narval_model/Armature_001.hide()
			$narwhal_skin/narval_model/Armature_002.show()
			$narwhal_skin/narval_model/Armature_003.hide()
		Global.weapons.TONFA:
			Global.current_weapon == 2
			$narwhal_skin/narval_model/Armature_001.show()
			$narwhal_skin/narval_model/Armature_002.hide()
			$narwhal_skin/narval_model/Armature_003.hide()

func attack() -> void:
	if Global.current_weapon == Global.weapons.TONFA:
		$narwhal_skin/narval_model/Armature_001/Skeleton3D/tonfa/area/CollisionShape3D.set_deferred("disabled", true)
		$narwhal_skin/narval_model/attack_player.play("tonfa_attack")
		await $narwhal_skin/narval_model/attack_player.animation_finished
		$narwhal_skin/narval_model/Armature_001/Skeleton3D/tonfa/area/CollisionShape3D.set_deferred("disabled", false)
	elif Global.current_weapon == Global.weapons.BAT:
		$narwhal_skin/narval_model/Armature_002/Skeleton3D/bat/Area3D/CollisionShape3D.set_deferred("disabled", false)
		$narwhal_skin/narval_model/attack_player.play("bat_attack")
		await $narwhal_skin/narval_model/attack_player.animation_finished
		$narwhal_skin/narval_model/Armature_002/Skeleton3D/bat/Area3D/CollisionShape3D.set_deferred("disabled", true)
	else:
		print("sem nenhuma arma equipada")


func get_immune(immune_time:= 5.0) -> void:
	immune = true
	$torus_mesh.show()
	set_collision_mask_value(2, false)
	await(get_tree().create_timer(immune_time).timeout)
	set_collision_mask_value(2, true)
	$torus_mesh.hide()
	immune = false

func change_mouse_sens(sens: float) -> void:
	mouse_sens = sens

func _on_player_hitbox_area_entered(area: Area3D) -> void:
	if area.is_in_group("enemies"):
		stunned = true
		var body_collision = (skin.global_position - area.global_position)
		body_collision.y = 0.0
		var force = body_collision
		force = force * 2.0
		knockback(force, body_collision)
		await(get_tree().create_timer(.3).timeout)
		knockbacked = false
		stunned = false
	
func magic() -> void:
	if is_on_floor() and magic_selec == 1:
		$magics.rotation.y = skin.rotation.y
		stunned = true
		velocity = Vector3(0,0,0) 
		Global.player_can_move = false #impede o player de se mover enquanto faz a magia
		$magics/CSGCombiner3D.show()
		await(get_tree().create_timer(.6).timeout)
		$magics/dust_magic/CollisionShape3D.set_deferred("disabled",false)
		await(get_tree().create_timer(.8).timeout)
		Global.player_can_move = true
		$magics/dust_magic/CollisionShape3D.set_deferred("disabled",true)
		$magics/CSGCombiner3D.hide()
		stunned = false
	if is_on_floor() and magic_selec == 2:
		$magics/mandala.show()
		stunned= true
		await(get_tree().create_timer(1).timeout)
		var pre_boost = Global.player_damage
		Global.player_damage = Global.player_damage + (Global.player_damage/3)
		stunned = false 
		$magics/mandala.hide()
		await(get_tree().create_timer(5).timeout)
		Global.player_damage = pre_boost
		#print(Global.player_damage)
	if is_on_floor() and magic_selec == 3:
		$magics.rotation.y = skin.rotation.y
		get_immune(3.0)
		$magics/crab.show()
		stunned= true
		await(get_tree().create_timer(3).timeout)
		stunned = false 
		$magics/crab.hide()
