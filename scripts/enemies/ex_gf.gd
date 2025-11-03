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

var original_resource: StandardMaterial3D = load("res://shaders/ex_skin.tres")
var unique_resource: Object = original_resource.duplicate()

@onready var player: CharacterBody3D = $"../player"


func _ready() -> void:
	$ex_model/body.material_overlay = unique_resource
	unique_resource.albedo_color = Color("e3405cff")
	$ex_model/body.material_overlay = null
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
	$ex_model/body.material_overlay = unique_resource
	calculate_knockback(area)
	await(get_tree().create_timer(.4).timeout)
	$ex_model/body.material_overlay = null
	teleporting()
	
func unique_die()-> void:
	is_dying = true
	set_collision_mask_value(2, false)
	set_collision_mask_value(3, false)
	$ex_model.set_state("ex_escape")
	await(get_tree().create_timer(1).timeout)

func look_to_player(delta : float)-> void:
	var pos2d: Vector2 = Vector2(global_position.x, global_position.z)
	var targetpos2d: Vector2 = Vector2(player.global_position.x, player.global_position.z)
	var target_angle = pos2d - targetpos2d
	global_rotation.y = lerp_angle(rotation.y,atan2(target_angle.x, target_angle.y), delta * 1.5)

func shoot() -> void:
	var pearl: Object = pearlins.instantiate()
	if state == "blush":
		pearl.blush = true
		$ex_model.set_state("blush")
		await(get_tree().create_timer(.4).timeout)
	elif state != "blush":
		$ex_model.set_state("blush_throw")
		await(get_tree().create_timer(.4).timeout)
	pearl.pos = $shoot.global_position
	pearl.rot = rotation
	pearl.follow = false
	pearl.speed = bullet_speed
	pearl.damage = damage
	#futuramente determinar o molde do projetil
	get_parent().add_child(pearl)
	$ex_model.set_state("idle")


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
		$ex_model.set_state("summon")
		await(get_tree().create_timer(.5).timeout)
		var dragon1: Object = dragonins.instantiate()
		dragon1.global_rotation = $invocation_point1.global_rotation
		dragon1.global_position = $invocation_point1.global_position
		get_parent().add_child(dragon1)
		if level >= 2:
			state = "blush"
		else: 
			state = "shooting"
		await(get_tree().create_timer(1.2).timeout)
		$ex_model.set_state("idle")
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
