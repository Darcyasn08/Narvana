extends CharacterBody3D


var speed : float = 5.0
var on_ground : bool = false
var life : int = 500
var damage : int = 1
var acceleration : float = 15.0
var fall_time: float
var can_move: bool = true

@export var min_coins: int = 2
@export var max_coins: int = 3

@onready var player = $"../player"
@onready var collision: CollisionShape3D = $collision
@onready var collision_2: CollisionShape3D = $collision2

func _ready() -> void:
	on_ground = true
	fall()
	await(get_tree().create_timer(fall_time).timeout)
	on_ground = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if on_ground == false and is_on_floor() and can_move:
		look_to_player(delta)#muda a rotação do bixo pra ficar de frente com o player
		rotation.x = 0
		var forward := global_basis.z #determina oq é a frente 
		var move_direction := forward 
		move_direction.y = 0.0 #reseta o de y, pq ele não muda na hora de mover
		move_direction = move_direction.normalized() #nao sei oq isso faz
		velocity = velocity.move_toward(move_direction * -speed, acceleration * delta) #move pra frente
		velocity.y = 0
	
	move_and_slide()

func unique_take_damage(area) -> void:
	#print("i was hit by a weapon!!",life)
	on_ground = true
	fall()
	calculate_knockback(area)
	await(get_tree().create_timer(fall_time).timeout)
	on_ground = false

func damage_player(area) -> void:
	get_tree().call_group("player","hurt",damage)
	on_ground = true
	fall()
	calculate_knockback(area)
	await(get_tree().create_timer(fall_time).timeout)
	on_ground = false

func unique_die() -> void:
	print("im dead dude...")
	can_move = false
	#hide() #colocar a animação de morte aqui depois

func fall() -> void:
	fall_time = randf_range(1.3,2.8)
	$uped.hide()
	$falled.show()
	$enemy_hitbox.monitoring = false
	collision.set_deferred("disabled", true)
	$enemy_hitbox.set_deferred("monitoring", false)
	await(get_tree().create_timer(fall_time).timeout)
	$uped.show()
	$falled.hide()
	collision.set_deferred("disabled", false)
	$enemy_hitbox.set_deferred("monitoring", true)


func knockback(force: Vector3, impact_point: Vector3) -> void:
	velocity = force.limit_length(15.0)

func calculate_knockback(area: Area3D) -> void:
	var body_collision = (global_position - area.global_position)
	body_collision.y = 0.0
	var force = body_collision
	force = force * 5.0
	knockback(force, body_collision)
	await(get_tree().create_timer(.3).timeout)
	velocity = velocity * 0


func look_to_player(delta : float) -> void:
	var pos2d: Vector2 = Vector2(global_position.x, global_position.z)
	var targetpos2d: Vector2 = Vector2(player.global_position.x, player.global_position.z)
	var target_angle = pos2d - targetpos2d
	global_rotation.y = lerp_angle(rotation.y,atan2(target_angle.x, target_angle.y), 0.1)
