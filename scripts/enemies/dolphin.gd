extends CharacterBody3D

var life: int = 2000
var damage: int = 1
var bullet_speed: float = 20.0
var level: int = 2
var state : String = "going"
var speed : float = 10.0
var acceleration : float = 15.0
var beating_number : int = 1
var target_angle : float 
var spaw_point : Vector3

var paperins = preload("res://scenes/projectile.tscn")

@onready var player = $"../player"

func _ready() -> void:
	spaw_point = global_position
	SignalBus.on_ex_crying.connect(office_jump)

func _physics_process(delta: float) -> void:
	if not is_on_floor() and state != "jumping" and state != "fall":
		velocity += get_gravity() * delta
	
	if state == "going" or state == "papers" or state == "waiting":
		look_to_player()
		
	if state == "going":
		rotation.x = 0
		var forward := global_basis.z #determina oq é a frente 
		var move_direction := forward 
		move_direction.y = 0.0 #reseta o de y, pq ele não muda na hora de mover
		move_direction = move_direction.normalized() #nao sei oq isso faz
		velocity = velocity.move_toward(move_direction * -speed, acceleration * delta) #move pra frente
		velocity.y = 0
		
	if state == "tailing":
		global_rotation.y = lerp_angle(global_rotation.y,target_angle,acceleration/3 * delta)

	move_and_slide()


func damage_player(area)-> void:
	if state == "heading" or state == "tailing":
		get_tree().call_group("player","hurt",damage)
	calculate_knockback(area)


func knockback(force: Vector3, impact_point: Vector3)-> void:
	velocity = force.limit_length(15.0)


func calculate_knockback(area: Area3D)-> void:
	var body_collision = (global_position - area.global_position)
	body_collision.y = 0.0
	var force = body_collision
	force = force * Global.knock_multi
	knockback(force, body_collision)
	await(get_tree().create_timer(.3).timeout)
	velocity = velocity * 0

func unique_take_damage(area)-> void:
	calculate_knockback(area)

func unique_die()-> void:
	pass

func look_to_player()-> void:
	var pos2d: Vector2 = Vector2(global_position.x, global_position.z)
	var targetpos2d: Vector2 = Vector2(player.global_position.x, player.global_position.z)
	var target_angle = pos2d - targetpos2d
	global_rotation.y = lerp_angle(rotation.y,atan2(target_angle.x, target_angle.y), .1)

func _on_timer_timeout() -> void:
	if state == "papers":
		shoot()
		state = "buffing"
		$Timer.wait_time = 1.0
		$Timer.start()
	elif state == "buffing":
		$smoke.show()
		damage = 2
		await(get_tree().create_timer(2).timeout)
		state = "going"
		await(get_tree().create_timer(10).timeout)
		$smoke.hide()
		damage = 1


func _on_player_detection_area_entered(area: Area3D) -> void:
	if area.name == "player_hitbox" and state == "going" and beating_number == 2:
		state = ""
		velocity = Vector3(0,0,0)
		target_angle = deg_to_rad(rad_to_deg(global_rotation.y) + 180)
		await(get_tree().create_timer(0.7).timeout)
		state = "tailing" 
		await(get_tree().create_timer(2).timeout)
		beating_number = 1
		state = "papers"
		$Timer.wait_time = 2.0
		$Timer.start()
	elif area.name == "player_hitbox" and state == "going" and beating_number == 1:
		state = "heading"
		velocity = Vector3(0,0,0)
		await(get_tree().create_timer(1).timeout)
		var forward := global_basis.z #determina oq é a frente 
		var move_direction := forward 
		move_direction.y = 0.0 #reseta o de y, pq ele não muda na hora de mover
		move_direction = move_direction.normalized() #nao sei oq isso faz
		velocity = velocity.move_toward(move_direction * -speed, acceleration)
		await(get_tree().create_timer(1).timeout)
		velocity = Vector3(0,0,0)
		look_to_player()
		await(get_tree().create_timer(2).timeout)
		beating_number = 2
		state = "going"


func shoot() -> void:
	var paper: Object = paperins.instantiate()
	paper.pos = $shooter.global_position
	paper.rot = rotation
	paper.follow = false
	paper.speed = bullet_speed
	paper.damage = damage
	paper.stunner = true
	paper.stun_time = 3.0
	#futuramente determinar o molde do projetil
	get_parent().add_child(paper)

func office_jump() -> void:
	state = "waiting"
	velocity = Vector3.ZERO
	global_position = spaw_point
	await(get_tree().create_timer(2).timeout)
	$player_detection/area.disabled = true
	$enemy_hitbox/hitbox.disabled = true
	$model.hide()
	$warning.show()
	state = "jumping"
	speed = speed/2
	$collision.disabled = true
	await(get_tree().create_timer(10).timeout)
	$model.show()
	$warning.hide()
	state = "fall"
	velocity = Vector3.ZERO
	$impact_area/impact.disabled = false
	await(get_tree().create_timer(.5).timeout)
	$impact_area/impact.disabled = true
	await(get_tree().create_timer(5).timeout)
	
	$player_detection/area.disabled = false
	$enemy_hitbox/hitbox.disabled = false
	$collision.disabled = false
	speed = speed*2
	state = "going"


func _on_impact_area_area_entered(area: Area3D) -> void:
	if area.name == "player_hitbox":
		get_tree().call_group("player","hurt",damage)
