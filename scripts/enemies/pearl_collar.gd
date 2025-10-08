extends CharacterBody3D

var speed: float = 3.0
var life: int = 700
var damage: int = 1
var acceleration: float = 9.0
var pearlins = preload("res://scenes/projectile.tscn")
var bullet_speed: float = 16.0
var random: int 
var swimming: bool = false
var shots: int = 5

@onready var player = $"../player"

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if swimming == false:
		look_at(player.global_position)
	
	move_and_slide()


func _on_timer_timeout() -> void:
	await atirar()
	await(get_tree().create_timer(2).timeout) 
	await andar()
	$Timer.start(2)
	

func atirar() -> void:
	var pearl = pearlins.instantiate()
	pearl.pos = $Node3D.global_position
	pearl.rot = rotation
	pearl.follow = false
	pearl.speed = bullet_speed
	pearl.damage = damage
	#futuramente determinar o molde do projetil
	get_parent().add_child(pearl)
	shots -= 1
	if shots == 0:
		queue_free()
	
func andar() -> void:
	swimming = true
	random = randi_range(0 , 360)
	rotation.y = deg_to_rad(float(random))
	random = randi_range(1,6)
	var forward := global_basis.z #determina oq é a frente 
	forward = forward.normalized()
	velocity = velocity.move_toward(forward * -speed, 20000 )
	await(get_tree().create_timer(random).timeout)
	swimming = false
	velocity = Vector3(0,0,0)
	
func knockback(force: Vector3, impact_point: Vector3) -> void:
	velocity = force.limit_length(15.0)


func calculate_knockback(area: Area3D) -> void:
	var body_collision = (global_position - area.global_position)
	body_collision.y = 0.0
	var force = body_collision
	knockback(force, body_collision)
	await(get_tree().create_timer(.3).timeout)
	velocity = velocity * 0
	
	
func unique_take_damage(area) -> void:
	calculate_knockback(area)
	
func unique_die() -> void:
	pass
	
func damage_player(_area) -> void:
	pass

#func _on_hitbox_area_entered(area: Area3D) -> void:
	#if area.is_in_group("weapon"):
		#if life > Global.player_damage :
			#life -= Global.player_damage
			#print(life)
			#calculate_knockback(area)
		#else: 
			#queue_free()
