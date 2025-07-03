extends CharacterBody3D

var speed: float = 1.0
var life: int= 1000
var damage: int = 1
var acceleration: float = 10.0
var coinins = preload("res://scenes/coin.tscn")

@onready var player = $"../player"

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if is_on_floor() == true:
		look_at(player.global_position) #muda a rotação do bixo pra ficar de frente com o player
		rotation.x = 0
		var forward := global_basis.z #determina oq é a frente 
		var move_direction := forward 
		move_direction.y = 0.0 #reseta o de y, pq ele não muda na hora de mover
		move_direction = move_direction.normalized() #nao sei oq isso faz
		velocity = velocity.move_toward(move_direction * -speed, acceleration * delta) #move pra frente
		velocity.y = 0
	
	var ground_speed := velocity.length()
	if ground_speed > 0.0:
		$"piggy-bank-enemy/AnimationPlayer".play("walk")
	elif ground_speed <= 0.0:
		$"piggy-bank-enemy/AnimationPlayer".stop()
	
	move_and_slide()


func knockback(force: Vector3, impact_point: Vector3):
	velocity = force.limit_length(15.0)


func calculate_knockback(area: Area3D):
	var body_collision = (global_position - area.global_position)
	body_collision.y = 0.0
	var force = body_collision
	knockback(force, body_collision)
	await(get_tree().create_timer(.3).timeout)
	velocity = velocity * 0

func unique_take_damage(area):
	calculate_knockback(area)

func damage_player(area):
	get_tree().call_group("player","hurt",damage)

func unique_die():
	await(get_tree().create_timer(.1).timeout)
	var coin1 = coinins.instantiate()
	coin1.position = $coinslot1.global_position #determina o local onde a moeda vai spawnar
	coin1.rotation = $coinslot1.global_rotation #determina a rotação q a moeda vai spawnar
	var coin2 = coinins.instantiate()
	coin2.position = $coinslot2.global_position
	coin2.rotation = $coinslot2.global_rotation
	var coin3 = coinins.instantiate()
	coin3.position = $coinslot3.global_position
	coin3.rotation = $coinslot3.global_rotation
	get_parent().add_child(coin1) #spawna a moeda
	get_parent().add_child(coin2)
	get_parent().add_child(coin3)
	print("im deaaaddd noooooo")
