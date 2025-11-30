extends CharacterBody3D

var state : String = "chasing"
var speed : float = 3.0
var life : int = 1600
var damage : int = 1
var acceleration : float = 15.0
var no_hit : bool = true
var coffee_level : int = 0


var player_path: String = "player"
@onready var player: CharacterBody3D = get_node(player_path)

func _ready() -> void:
	while player == null:
		player_path = "../"+player_path
		player = get_node(player_path)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if state == "chasing" and is_on_floor():
		look_to_player()#muda a rotação do bixo pra ficar de frente com o player
		rotation.x = 0
		var forward := global_basis.z #determina oq é a frente 
		var move_direction := forward 
		move_direction.y = 0.0 #reseta o de y, pq ele não muda na hora de mover
		move_direction = move_direction.normalized() #nao sei oq isso faz
		velocity = velocity.move_toward(move_direction * -speed, acceleration * delta) #move pra frente
		velocity.y = 0
	move_and_slide()


func damage_player(area) -> void:
	if coffee_level < 3:
		coffee_level += 1
		SignalBus.on_coffee_hits.emit(coffee_level)
	get_tree().call_group("player","hurt",damage)
	calculate_knockback(area)
	if no_hit == false:
		teleport()

func knockback(force: Vector3, impact_point: Vector3) -> void:
	velocity = force.limit_length(15.0)


func calculate_knockback(area) -> void:
	var body_collision = (global_position - area.global_position)
	body_collision.y = 0.0
	var force = body_collision
	force = force * Global.knock_multi
	knockback(force, body_collision)
	await(get_tree().create_timer(.3).timeout)
	velocity = velocity * 0

func unique_take_damage(area) -> void:
	if no_hit == false:
		teleport()
	if no_hit:
		#animação dele vazando a poça de cafe? eu acho
		$"../puddle".global_position =Vector3(global_position.x,global_position.y + .6, global_position.z)
		$"../puddle".show()
		speed = speed * 2
		no_hit = false
	calculate_knockback(area)
	

func unique_die() -> void:
	coffee_level = 0 
	SignalBus.on_coffee_hits.emit(coffee_level)
	$"..".queue_free()

func look_to_player() -> void:
	var pos2d: Vector2 = Vector2(global_position.x, global_position.z)
	var targetpos2d: Vector2 = Vector2(player.global_position.x, player.global_position.z)
	var target_angle = pos2d - targetpos2d
	rotation.y = lerp_angle(rotation.y,atan2(target_angle.x, target_angle.y),.1)
	

func teleport()->void:
	$Timer.stop()
	#animação dele teleportando
	%coffe_model.set_state("teleport")
	await(get_tree().create_timer(0.2).timeout)
	var xp : float = randf_range($"../puddle".global_position.x - 6.8,$"../puddle".global_position.x + 6.8)
	var zp : float = randf_range($"../puddle".global_position.z - 6.8,$"../puddle".global_position.z + 6.8)
	global_position = Vector3(xp,$"../puddle".global_position.y,zp)
	%coffe_model.set_state_back("teleport")
	$Timer.wait_time = 10.0
	$Timer.start()
	await(get_tree().create_timer(0.2).timeout)
	%coffe_model.set_state("idle")


func _on_timer_timeout() -> void:
	teleport()
