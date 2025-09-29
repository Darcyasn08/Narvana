extends CharacterBody3D

var state : String = "waiting"
var speed : float = 3.0
var life : int = 850
var damage : int = 1
var acceleration : float = 15.0
var time_dashing : float = 2.0
var dashs : int = 0
var drift_side : int = 1
var defence : float = 0.75

@onready var player = $"../player"


func _physics_process(delta: float) -> void:

	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if state == "waiting" or state =="drifting" :
		look_to_player()
		
	if state == "dashing":
		rotation.x = 0
		var forward := global_basis.z #determina oq é a frente 
		var move_direction := forward 
		move_direction.y = 0.0 #reseta o de y, pq ele não muda na hora de mover
		move_direction = move_direction.normalized() #nao sei oq isso faz
		velocity = velocity.move_toward(move_direction * (-speed*5) , acceleration * delta) #move pra frente
		velocity.y = 0
	if state == "drifting":
		rotation.x = 0
		var side := global_basis.x #determina oq é a frente 
		var move_direction := side
		move_direction.y = 0.0 #reseta o de y, pq ele não muda na hora de mover
		move_direction = move_direction.normalized() #nao sei oq isso faz
		velocity = velocity.move_toward(move_direction *  (-speed*1.5*drift_side) , acceleration * delta) #move pra frente
		velocity.y = 0

	move_and_slide()

func damage_player(area) -> void:
	get_tree().call_group("player","hurt",damage)

func knockback(force: Vector3, impact_point: Vector3) -> void:
	velocity = force.limit_length(15.0)


func calculate_knockback(area) -> void:
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

func look_to_player() -> void:
	var pos2d: Vector2 = Vector2(global_position.x, global_position.z)
	var targetpos2d: Vector2 = Vector2(player.global_position.x, player.global_position.z)
	var target_angle = pos2d - targetpos2d
	global_rotation.y = lerp_angle(rotation.y,atan2(target_angle.x, target_angle.y),.05)


func _on_enemy_hitbox_body_entered(body: Node3D) -> void:
	if !body.is_in_group("enemies") and state == "dashing":
		velocity = Vector3(0,0,0)
		state = "knocked"
		defence = 1
		dashs = 0
		$torus_mesh.show()
		await(get_tree().create_timer(5).timeout)
		state = "waiting"
		$torus_mesh.hide()
		defence = 0.75
		$Timer.wait_time = 3
		$Timer.start()
		


func _on_timer_timeout() -> void:
	state = "dashing"
	dashs += 1
	if dashs < 3:
		await(get_tree().create_timer(time_dashing).timeout)
		if state != "knocked":
			var sider = global_rotation.y
			state = "drifting"
			await (get_tree().create_timer(0.02).timeout)
			
			if sider > global_rotation.y:
				drift_side = 1

			if sider < global_rotation.y: 

				drift_side = -1
			await (get_tree().create_timer(1.7).timeout)
			print(drift_side)
			state = "waiting"
			velocity = Vector3(0,0,0)
			$Timer.wait_time = 3
			$Timer.start()
			
			
