extends CharacterBody3D

# VARIÁVEIS EM REAÇÃO A MOVIMENTAÇÃO
var JUMP_VELOCITY: float = 4
var camera_input_direction: Vector2 = Vector2.ZERO
var last_movement_direction: Vector3 = Vector3.BACK
var mouse_sens: float = .11
var move_speed: float = 8.0
var acceleration: float = 15.0
var rotation_speed: float = 20.0
var jump_impulse: float = 12.0
var gravity: float = -30.0
var ground_speed: float
var magic_time : float = 80.0
var magic_col : bool = false
var special_col : bool = false
var special_time : float = 20.0
var bubbles_rmn : int = 0
var is_shark_attack: bool = false
var attack_combo_time: float = .8
var combo_attack_count: int = 0
var state : String = ""

# OUTRAS VARIÁVEIS (depois eu separo isso melhor)
var health: int = 6
var dashed: bool = false
var knockbacked: bool = false
var stunned: bool = false
var immune: bool = false
var immune_time: float = 2.5
var is_attacking: bool = false

# VARIÁVEIS DE IMPRTAÇÃO
@onready var camera_pivot: Node3D = $camera_pivot
@onready var camera: Camera3D = $camera_pivot/SpringArm3D/Camera3D
@onready var skin: Node3D = $narwhal_skin
@onready var death_screen_inst: Object = preload("res://scenes/UI/death_screen.tscn")
@onready var skin_material: Object = load("res://shaders/narval-body-shader.tres")
@onready var previous_skin_color: Color = skin_material.albedo_color


func _ready() -> void:
	$player_hitbox/CollisionShape3D.set_deferred("disabled",true)
	SignalBus.on_changed_mouse_sens.connect(change_mouse_sens)
	SignalBus.on_change_player_weapon.connect(change_current_weapon)
	SignalBus.on_game_saved.connect(update_current_pos)
	SignalBus.on_stun_hit.connect(stunned_by_enemy)
	SignalBus.on_set_player_pos.connect(set_player_pos)
	change_current_weapon(Global.current_weapon)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	health = Global.player_health
	SignalBus.on_player_health_changed.emit(health)
	await get_tree().create_timer(.16).timeout
	$player_hitbox/CollisionShape3D.set_deferred("disabled",false)

func _physics_process(delta: float) -> void:
	#se o player cair, ele pelo menos volta pra plataforma (vou arrumar isso depois)
	if position.y < -50:
		position = Global.player_base_pos
	
	# MOVIMENTO DA CÂMERA
	camera_pivot.rotation.x += (camera_input_direction.y * delta)*Global.rotation_mouse_axis_x
	camera_pivot.rotation.x = clamp(camera_pivot.rotation.x, -PI/6, PI/4) #limitar a rotação
	camera_pivot.rotation.y += (-camera_input_direction.x * delta)*Global.rotation_mouse_axis_y
	
	camera_input_direction = Vector2.ZERO #a cada frame resetar, pra não rodar pra sempre
	
	if Global.player_can_move:
		var raw_input: Vector2 = Input.get_vector("a", "d", "w", "s")
		var forward: Vector3 = camera.global_basis.z
		var right: Vector3 = camera.global_basis.x
		
		var move_direction: Vector3 = forward * raw_input.y + right * raw_input.x #combina os valores de x e z
		move_direction.y = 0.0 #reseta o de y, pq ele não muda na hora de mover
		move_direction = move_direction.normalized()
	
		if move_direction.length() > 0.2:
			last_movement_direction = move_direction
		
		var target_angle: float = Vector3.BACK.signed_angle_to(last_movement_direction, Vector3.UP)
		if !is_attacking:
			skin.global_rotation.y = lerp_angle(skin.global_rotation.y,target_angle,rotation_speed *delta)
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

	var is_starting_jump := Input.is_action_pressed("space") and is_on_floor() and stunned == false and acceleration < 20.0
	if is_starting_jump:
		velocity.y += jump_impulse
	
	if state == "spinning":
		$weapons_special.rotation.y += 0.07
	$combo_timer_label.text = str(snapped($combo_attack_timer.time_left, 0.1))
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
		is_attacking = true
		match combo_attack_count:
			0:
				combo_attack_count = 1
			1:
				combo_attack_count = 2
			2:
				combo_attack_count = 3
			3:
				combo_attack_count = 0
				$narwhal_skin/narval_model/attack_player.play("RESET")
		skin.rotation_degrees.y = camera_pivot.rotation_degrees.y + 180
		attack()
		#$attack_sfx.play()
	
	if event.is_action_pressed("left_click") and Global.player_can_move:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
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
	
	if event.is_action_pressed("r"):
		magic()
	
	if event.is_action_pressed("shift") and dashed == false and is_on_floor(): #tem o is on floor pra nao dar dash no ar
		dash()
		$narwhal_skin/dash_bubble_particle.emitting = true
		await get_tree().create_timer(1).timeout
		$narwhal_skin/dash_bubble_particle.emitting = false
	
	if event.is_action_pressed("q"):
		special_attack()
	
	if event.is_action_pressed("q") and state == "shield" and is_on_floor():
		$narwhal_skin/narval_model/attack_player.play("tonfa_shield_special")
		Global.player_can_move = false
		Global.player_can_attack = false
		await get_tree().create_timer(.08).timeout
		$magics.rotation = skin.rotation
		$magics/shield_holder/shelld.disabled = false
		$magics/shield_holder/shield_detection/shelld.disabled = false
		velocity = Vector3.ZERO
	
	if event.is_action_released("q") and state == "shield":
		await get_tree().create_timer(.3).timeout
		deactivate_shield()
	



func hurt(damage) -> void:
	if damage < Global.player_health and immune == false:
		get_immune(immune_time)
		skin_material.albedo_color = Color(0.522, 0.243, 0.522, 1.0)
		$hurt_sfx.play()
		Global.player_health -= damage
		health = Global.player_health
		print("player health: ",Global.player_health)
		SignalBus.on_player_health_changed.emit(Global.player_health)
		await get_tree().create_timer(.1).timeout
		skin_material.albedo_color = previous_skin_color
	elif damage >= health and immune == false:
		health = 0
	if health == 0:
		SignalBus.on_player_health_changed.emit(health)
		die()
	$camera_pivot/SpringArm3D/Camera3D.add_trauma(.7)


# próxima atualização: fazer tela de morte
func die() -> void:
	print("morreu")
	get_tree().paused = true
	var death_screen: Object = death_screen_inst.instantiate()
	add_child(death_screen)

func dash() -> void:
	dashed = true
	move_speed += 125
	acceleration += 150
	await(get_tree().create_timer(.2).timeout)
	move_speed -= 125
	await(get_tree().create_timer(.2).timeout)
	acceleration -= 110
	await(get_tree().create_timer(.1).timeout)
	acceleration -= 40
	await(get_tree().create_timer(.8).timeout)
	dashed = false


func knockback(force: Vector3, _impact_point: Vector3) -> void:
	velocity = force.limit_length(15.0)

func shake_camera() -> void:
	pass

func change_current_weapon(weapon: int) -> void:
	print("received weapon: ",weapon)
	match weapon:
		Global.weapons.NONE:
			Global.current_weapon = Global.weapons.NONE
			$narwhal_skin/narval_model/Armature_001.hide()
			$narwhal_skin/narval_model/Armature_002.hide()
			$narwhal_skin/narval_model/Armature_003.show()
		Global.weapons.BAT:
			Global.current_weapon = 1
			$narwhal_skin/narval_model/Armature_001.hide()
			$narwhal_skin/narval_model/Armature_002.show()
			$narwhal_skin/narval_model/Armature_003.hide()
			Global.player_damage = 220
		Global.weapons.TONFA:
			Global.current_weapon = 2
			$narwhal_skin/narval_model/Armature_001.show()
			$narwhal_skin/narval_model/Armature_002.hide()
			$narwhal_skin/narval_model/Armature_003.hide()
			Global.player_damage = 280

func attack() -> void:
	if Global.current_weapon == Global.weapons.TONFA:
		$narwhal_skin/narval_model/Armature_001/Skeleton3D/tonfa/area/CollisionShape3D.set_deferred("disabled", false)
		if bubbles_rmn > 0:
			$narwhal_skin/narval_model/attack_player.play("tonfa_bubble_attack")
		elif is_shark_attack:
			$narwhal_skin/narval_model/attack_player.play("tonfa_shark_attack")
		else:
			$narwhal_skin/narval_model/attack_player.play("tonfa_attack")
		$combo_attack_timer.start()
		await $narwhal_skin/narval_model/attack_player.animation_finished
		$narwhal_skin/narval_model/Armature_001/Skeleton3D/tonfa/area/CollisionShape3D.set_deferred("disabled", true)
		if bubbles_rmn > 0:
			bubbles_rmn -= 1
		if bubbles_rmn == 0:
			Global.knock_multi = 5.0
	elif Global.current_weapon == Global.weapons.BAT:
		$narwhal_skin/narval_model/Armature_002/Skeleton3D/bat/Area3D/CollisionShape3D.set_deferred("disabled", false)
		#combo_attack_count += 1
		Global.player_can_attack = false
		match combo_attack_count:
			1:
				$narwhal_skin/narval_model/attack_player.play("bat_first_attack")
			2:
				$narwhal_skin/narval_model/attack_player.play("bat_second_attack")
			3:
				$narwhal_skin/narval_model/attack_player.play("bat_third_attack")
		await get_tree().create_timer(.22).timeout
		$combo_attack_timer.start()
		await get_tree().create_timer(.1).timeout
		Global.player_can_attack = true
		await $narwhal_skin/narval_model/attack_player.animation_finished
		$narwhal_skin/narval_model/Armature_002/Skeleton3D/bat/Area3D/CollisionShape3D.set_deferred("disabled", true)
	else:
		print("sem nenhuma arma equipada")


func get_immune(time: float = 5.0) -> void:
	immune = true
	$torus_mesh.show()
	set_collision_mask_value(2, false)
	await(get_tree().create_timer(time).timeout)
	set_collision_mask_value(2, true)
	$torus_mesh.hide()
	immune = false

func set_player_pos(pos: Vector3, rot: Vector3) -> void:
	$fade_canvas.show()
	$fade_canvas/AnimationPlayer.play("fade_in_out")
	await get_tree().create_timer(.02).timeout
	position = pos
	#rotation = rot
	await $fade_canvas/AnimationPlayer.animation_finished
	$fade_canvas.hide()

func change_mouse_sens(sens: float) -> void:
	mouse_sens = sens

func _on_player_hitbox_area_entered(area: Area3D) -> void:
	if area.is_in_group("enemies"):
		stunned = true
		var body_collision: Vector3 = (skin.global_position - area.global_position)
		body_collision.y = 0.0
		var force: Vector3 = body_collision
		force = force * 2.0
		knockback(force, body_collision)
		await(get_tree().create_timer(.3).timeout)
		knockbacked = false
		stunned = false


func update_current_pos() -> void:
	#ele irá salvar a última posição apenas quando estiver na vila
	if Global.current_world == Global.worlds.NORMAL:
		Global.last_saved_pos = position


func magic() -> void:
	if is_on_floor() and magic_col == false:
		magic_col = true
		if Global.magic_select == 1:
			$narwhal_skin/narval_model/attack_player.play("dust_magic")
			$magics.rotation.y = skin.rotation.y
			stunned = true
			velocity = Vector3(0,0,0) 
			Global.player_can_move = false #impede o player de se mover enquanto faz a magia
			$magics/sandbox_magic.show()
			$magics/sandbox_magic/bubble_particle.emitting = true
			await(get_tree().create_timer(.6).timeout)
			$magics/dust_magic/CollisionShape3D.set_deferred("disabled",false)
			await(get_tree().create_timer(.8).timeout)
			Global.player_can_move = true
			$magics/dust_magic/CollisionShape3D.set_deferred("disabled",true)
			$magics/sandbox_magic.hide()
			stunned = false
			magic_time = 75
		
		if Global.magic_select == 2:
			$magics.rotation.y = skin.rotation.y
			$magics/crab/AnimationPlayer.play("fade_in")
			get_immune(3.5)
			$magics/crab.show()
			stunned = true
			Global.player_can_move = false
			await(get_tree().create_timer(3.1).timeout)
			Global.player_can_move = true
			stunned = false 
			$magics/crab/AnimationPlayer.play("fade_out")
			await($magics/crab/AnimationPlayer.animation_finished)
			$magics/crab.hide()
			magic_time = 25
		
		if Global.magic_select == 3:
			$magics/mandala.show()
			stunned = true
			Global.player_can_move = false
			await(get_tree().create_timer(1).timeout)
			Global.player_damage = Global.player_damage + (Global.player_damage/3)
			stunned = false 
			Global.player_can_move = true
			$magics/mandala.hide()
			await(get_tree().create_timer(5).timeout)
			Global.player_damage = Global.player_damage - (Global.player_damage/3)
			#print(Global.player_damage)
			magic_time = 50
	
	SignalBus.on_use_magic.emit(magic_time)
	await(get_tree().create_timer(magic_time).timeout)
	magic_col = false 

func stunned_by_enemy(stun_time: float) -> void:
	Global.player_can_move = false
	print(stun_time)
	velocity = Vector3(0,0,0)
	await(get_tree().create_timer(stun_time).timeout)
	Global.player_can_move = true

func special_attack() -> void:
	if is_on_floor() and special_col == false:
		special_col = true
		if Global.current_weapon == 1:
			Global.player_can_move = false
			Global.player_can_attack = false
			velocity = Vector3.ZERO
			Global.player_damage = Global.player_damage/4
			for i: int in 8:
				$weapons_special/bambu_point.disabled = false
				await(get_tree().create_timer(.1).timeout)
				$weapons_special/bambu_point.disabled = true
				await(get_tree().create_timer(.2).timeout)
			Global.player_can_move = true
			Global.player_can_attack = true
			Global.player_damage = Global.player_damage*4
		if Global.current_weapon == 2:
			#var what_special : int = randi_range(1,3)
			var what_special: int = 3
			if what_special == 1:
				is_shark_attack = true
				$narwhal_skin/narval_model/attack_player.play("tonfa_shark_special")
				await(get_tree().create_timer(.2).timeout)
				Global.player_damage = Global.player_damage * 2
				await(get_tree().create_timer(5.0).timeout)
				Global.player_damage = Global.player_damage / 2
				is_shark_attack = false
			if what_special == 2:
				Global.player_can_attack = false
				$narwhal_skin/narval_model/attack_player.play("tonfa_bubble_special")
				await(get_tree().create_timer(.8).timeout)
				Global.player_can_attack = true
				Global.knock_multi = 16.0
				bubbles_rmn = 2
			if what_special == 3:
				state = "shield"
		if Global.current_weapon == 3:
			state = "spinning"
			$weapons_special/mangual.disabled = false
			$weapons_special.rotation = skin.rotation
			move_speed = 2.0
			Global.player_can_attack = false
			Global.player_damage = Global.player_damage / 2
			velocity = Vector3.ZERO
			await(get_tree().create_timer(5.0).timeout)
			move_speed = 8.0
			Global.player_damage = Global.player_damage * 2
			Global.player_can_attack = true
			$weapons_special/mangual.disabled = true
			state = ""
			
		await(get_tree().create_timer(special_time).timeout)
		deactivate_shield()
		state = ""
		special_col = false

func deactivate_shield() -> void:
	$narwhal_skin/narval_model/attack_player.play("RESET")
	$magics.rotation = skin.rotation
	$magics/shield_holder/shelld.disabled = true
	$magics/shield_holder/shield_detection/shelld.disabled = true
	Global.player_can_move = true
	Global.player_can_attack = true

func _on_shield_detection_area_entered(area: Area3D) -> void:
	if area.is_in_group("enemies") or area.is_in_group("multi_enemies"):
		deactivate_shield()
		state = ""

func _on_combo_attack_timer_timeout() -> void:
	combo_attack_count = 0
	$narwhal_skin/narval_model/attack_player.play("RESET")
	is_attacking = false
