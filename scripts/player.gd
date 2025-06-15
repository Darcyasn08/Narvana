extends CharacterBody3D


var JUMP_VELOCITY: float = 4
#var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var camera_input_direction := Vector2.ZERO
var last_movement_direction := Vector3.BACK

var mouse_sens: float = .11
var move_speed: float = 8.0
var acceleration: float = 15.0
var rotation_speed: float = 10.0
var jump_impulse: float = 12.0
var gravity: float = -30.0
var health: int = 6
var dashed: bool = false
var knockbacked: bool = false
var immune: bool = false
var sens := 0.07

@onready var camera_pivot: Node3D = $camera_pivot
@onready var camera: Camera3D = $camera_pivot/SpringArm3D/Camera3D
@onready var skin: Node3D = $narval_model


func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if position.y < -50:
		position = Global.player_base_pos
	
	camera_pivot.rotation.x += camera_input_direction.y * delta
	camera_pivot.rotation.x = clamp(camera_pivot.rotation.x, -PI/6, PI/4) #limitar a rotação
	camera_pivot.rotation.y += -camera_input_direction.x * delta
	
	camera_input_direction = Vector2.ZERO #a cada frame resetar, pra não rodar pra sempre
	
	var raw_input := Input.get_vector("a", "d", "w", "s")
	var forward := camera.global_basis.z
	var right := camera.global_basis.x
	
	var move_direction := forward * raw_input.y + right * raw_input.x #combina os valores de x e z
	move_direction.y = 0.0 #reseta o de y, pq ele não muda na hora de mover
	move_direction = move_direction.normalized()
	
	#print(move_direction)
	if !knockbacked:
		var y_velocity := velocity.y
		velocity.y = 0.0
		velocity = velocity.move_toward(move_direction * move_speed, acceleration * delta)
		velocity.y = y_velocity + gravity * delta
	
	var is_starting_jump := Input.is_action_pressed("space") and is_on_floor()
	if is_starting_jump:
		velocity.y += jump_impulse
	
	move_and_slide()
	dash()
	attack()
	
	if move_direction.length() > 0.2:
		last_movement_direction = move_direction
	
	var target_angle := Vector3.BACK.signed_angle_to(last_movement_direction, Vector3.UP)
	skin.global_rotation.y = lerp(skin.global_rotation.y, target_angle, rotation_speed * delta)
	#print("target: ", snapped(target_angle, 0.1), "  currnt: ", snapped(skin.global_rotation.y,.1))
	
	
	if not is_on_floor():
		pass
		#velocity.y -= gravity * delta
	
	if Input.is_action_just_pressed("space") and is_on_floor():#tem que ter o is on floor pra ele ficar pulando
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_pressed("e") and Global.player_can_attack: #arma temporaria só pra testes
		$Node3D.show()
		$Node3D/arma/CollisionShape3D.disabled = false
		#$Node3D.rotation.y = lerp($Node3D.rotation.y, 180.0, .001 )
		$AnimationPlayer2.play("bat_swing")
		await(get_tree().create_timer(.5).timeout)
		$Node3D.hide()
		$Node3D/arma/CollisionShape3D.disabled = true
		$Node3D.rotation.y = 0
	else:
		$Node3D.rotation.y = skin.rotation.y


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


func hurt(damage):
	if damage < health and immune == false:
		get_immune()
		health -= damage
		print(health)
	elif damage >= health and immune == false:
		health = 0
	if health == 0:
		die()


func die():
	print("morreu")


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


func knockback(force: Vector3, impact_point: Vector3):
	velocity = force.limit_length(15.0)


func _on_player_hitbox_area_shape_entered(area_rid: RID, area: Area3D, area_shape_index: int, local_shape_index: int) -> void:
	if area.is_in_group("enemies"):
		knockbacked = true
		var body_collision = (skin.global_position - area.global_position)
		body_collision.y = 0.0
		var force = body_collision
		force = force * 2.0
		knockback(force, body_collision)
		await(get_tree().create_timer(.3).timeout)
		knockbacked = false

func attack():
	if Input.is_action_pressed("e"): #arma temporaria só pra testes
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
	$CSGTorus3D.show()
	await(get_tree().create_timer(3).timeout)
	$CSGTorus3D.hide()
	immune = false
	
