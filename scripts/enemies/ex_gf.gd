extends CharacterBody3D

var life: int = 1950
var damage: int = 1
var bullet_speed: float = 20.0
var level: int = 2
var state: String = "dragons"
var speed: float = 12.0
var local_spawn : Vector3
var is_dying: bool = false

var dragonins: Object = preload("res://scenes/enemies/pearl_collar.tscn")
var pearlins: Object = preload("res://scenes/weapon/projectile.tscn")
var blushins: int = 1

@onready var player: CharacterBody3D = $"../player"


func _ready() -> void:
	print("on scene")
	local_spawn = global_position
	$Timer.start()


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	if !is_dying:
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
	await(get_tree().create_timer(.5).timeout)
	teleporting()
	
func unique_die()-> void:
	is_dying = true
	set_collision_mask_value(2, false)
	set_collision_mask_value(3, false)
	$ex_model/AnimationPlayer.play("ex_escape")
	await $ex_model/AnimationPlayer.animation_finished

func look_to_player(delta : float)-> void:
	var pos2d: Vector2 = Vector2(global_position.x, global_position.z)
	var targetpos2d: Vector2 = Vector2(player.global_position.x, player.global_position.z)
	var target_angle = pos2d - targetpos2d
	global_rotation.y = lerp_angle(rotation.y,atan2(target_angle.x, target_angle.y), delta * 1.5)

func shoot() -> void:
	var pearl: Object = pearlins.instantiate()
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
		await(get_tree().create_timer(2).timeout)
		shoot()
		await(get_tree().create_timer(2).timeout)
	if state == "blush":
		shoot()
		await(get_tree().create_timer(1).timeout)
		shoot()
		await(get_tree().create_timer(1).timeout)
		shoot()
		teleporting()
		state = "shooting"
		$Timer.wait_time = 1
		$Timer.start()
	elif state == "dragons":
		var dragon1: Object = dragonins.instantiate()
		dragon1.global_rotation = $invocation_point1.global_rotation
		dragon1.global_position = $invocation_point1.global_position
		var dragon2: Object = dragonins.instantiate()
		dragon2.global_rotation = $invocation_point2.global_rotation
		dragon2.global_position = $invocation_point2.global_position
		get_parent().add_child(dragon1)
		get_parent().add_child(dragon2)
		if level >= 2:
			state = "blush"
		else: 
			state = "shooting"
		await(get_tree().create_timer(1).timeout)
		teleporting()
		$Timer.wait_time = 1
		$Timer.start()
	elif state == "shooting":
			shoot()
			state = "dragons"
			await teleporting()
			$Timer.wait_time = 2
			$Timer.start()
			

func teleporting() -> void:
	var xp : float = randf_range(local_spawn.x - 9,local_spawn.x + 9)
	var zp : float = randf_range(local_spawn.z - 9,local_spawn.z + 9)
	global_position = Vector3(xp,local_spawn.y,zp)
	$ex_model/ex_arm1.hide()
	$ex_model/ex_arm2.hide()
	$ex_model/ex_body.hide()

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
