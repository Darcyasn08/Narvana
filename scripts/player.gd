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
var ground_speed

# OUTRAS VARIÁVEIS (depois eu separo isso melhor)
var health: int = 6
var dashed: bool = false
var knockbacked: bool = false
var stunned: bool = false
var immune: bool = false
var sens := 0.07
var immune_time: float = 2.5

# VARIÁVEIS DE IMPRTAÇÃO
@onready var camera_pivot: Node3D = $camera_pivot
@onready var camera: Camera3D = $camera_pivot/SpringArm3D/Camera3D
@onready var skin: Node3D = $narwhal_skin
@onready var death_screen_inst = preload("res://scenes/UI/death_screen.tscn")


func _ready() -> void:
	#print(Global.dialogs["crab"]["dialog_tree"].size())
	print(health)
	get_nodes()
	SignalBus.on_player_health_changed.emit(health)
	#SignalBus.on_dialog_activated.connect(set_move)


func _physics_process(delta: float) -> void:
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
		
		ground_speed = velocity.length()
		if ground_speed > 0.0:
			$narwhal_skin/narval_model/AnimationPlayer.play("walk")
			#print(ground_speed)
		elif ground_speed <= 0.0:
			$narwhal_skin/narval_model/AnimationPlayer.play("narwhal_idle")
		
		if !knockbacked:
			var y_velocity := velocity.y
			velocity.y = 0.0
			velocity = velocity.move_toward(move_direction * move_speed, acceleration * delta)
			velocity.y = y_velocity + gravity * delta
	else:
		ground_speed = 0
		velocity = Vector3(0,0,0)
		#print("you cant just move mate")

	var is_starting_jump := Input.is_action_pressed("space") and is_on_floor() and stunned == false
	if is_starting_jump:
		velocity.y += jump_impulse
	
	move_and_slide()
	dash()
	attack()
	magic()
	
	if not is_on_floor():
		pass
		#velocity.y -= gravity * delta


func _unhandled_input(event: InputEvent) -> void:
	var is_camera_motion := (
		event is InputEventMouseMotion and
		Input.mouse_mode == Input.MOUSE_MODE_CAPTURED
	)
	if is_camera_motion:
		camera_input_direction = event.relative * sens


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event.is_action_pressed("esc"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	#if event.is_action_pressed("e"):
		#var target = $RayCast3D.get_collider()
		#if target != null:
			#if target.is_in_group("npcs"):
				#print("hi npc!")
	
	
	#para o ataque
	#if event.is_action_pressed("e") and Global.player_can_attack:
		#attack()


func hurt(damage):
	if damage < health and immune == false:
		get_immune()
		#muda a cor da skin do narval
		health -= damage
		print(health)
		SignalBus.on_player_health_changed.emit(health)
	elif damage >= health and immune == false:
		health = 0
	if health == 0:
		SignalBus.on_player_health_changed.emit(health)
		die()


# próxima atualização: fazer tela de morte
func die():
	print("morreu")
	get_tree().paused = true
	var death_screen = death_screen_inst.instantiate()
	add_child(death_screen)

func dash():
	if Input.is_action_just_pressed("shift") and dashed == false and is_on_floor(): #tem o is on floor pra nao dar dash no ar
		dashed = true
		move_speed += 300
		acceleration += 300
		await(get_tree().create_timer(.05).timeout)
		move_speed -= 300
		acceleration -= 300
		await(get_tree().create_timer(1).timeout)
		dashed = false


func knockback(force: Vector3, _impact_point: Vector3):
	velocity = force.limit_length(15.0)


func attack():
	if Input.is_action_just_pressed("e") and Global.player_can_attack:
		if Global.current_weapon == "tonfa":
			$narwhal_skin/narval_model/Armature_001.show()
			$narwhal_skin/narval_model/Armature_002.hide()
			$narwhal_skin/narval_model/attack_player.play("tonfa_attack")
		elif Global.current_weapon == "bat":
			$narwhal_skin/narval_model/Armature_002.show()
			$narwhal_skin/narval_model/Armature_001.hide()
			$narwhal_skin/narval_model/attack_player.play("bat_attack")

func atta2ck():
	if Input.is_action_pressed("e") and Global.player_can_attack: #arma temporaria só pra testes
		$Node3D.show()
		$Node3D/arma/CollisionShape3D.disabled = false
		$Node3D.rotation.y = lerp($Node3D.rotation.y, 180.0, .001 )
		await(get_tree().create_timer(.3).timeout)
		$Node3D.hide()
		$Node3D/arma/CollisionShape3D.disabled = true
		$Node3D.rotation.y = skin.rotation.y
	else:
		$Node3D.rotation.y = skin.rotation.y


func get_immune():
	immune = true
	$torus_mesh.show()
	await(get_tree().create_timer(immune_time).timeout)
	$torus_mesh.hide()
	immune = false


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

func magic():
	if Input.is_action_just_pressed("r") and is_on_floor():
		$magics.rotation.y = skin.rotation.y
		stunned= true
		velocity = Vector3(0,0,0) #impede o player de se mover enquanto faz a magia
		$magics/CSGCombiner3D.show()
		await(get_tree().create_timer(1).timeout)
		$magics/dust_magic/CollisionShape3D.disabled = false 
		print($magics/dust_magic.monitorable)
		await(get_tree().create_timer(1).timeout)
		$magics/dust_magic/CollisionShape3D.disabled = true
		$magics/CSGCombiner3D.hide()
		stunned = false

func get_nodes():
	var node_n = 1
	var node = get_node("saidas/node"+str(node_n)+"/a1")
	print(node)
