extends CharacterBody3D


var speed := 5.0
var on_ground := false
var life := 500
var damage := 1
var acceleration := 15.0


@onready var player = $"../player"

func _ready() -> void:
	on_ground = true
	fall()
	await(get_tree().create_timer(5).timeout)
	on_ground = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if on_ground == false and is_on_floor():
		look_at(player.global_position)#muda a rotação do bixo pra ficar de frente com o player
		rotation.x = 0
		var forward := global_basis.z #determina oq é a frente 
		var move_direction := forward 
		move_direction.y = 0.0 #reseta o de y, pq ele não muda na hora de mover
		move_direction = move_direction.normalized() #nao sei oq isso faz
		velocity = velocity.move_toward(move_direction * -speed, acceleration * delta) #move pra frente
		velocity.y = 0

	move_and_slide()


func _on_hitbox_area_shape_entered(area_rid: RID, area: Area3D, area_shape_index: int, local_shape_index: int) -> void:
	if area.is_in_group("weapon"):
		if life > Global.player_damage :
			life -= Global.player_damage
			print(life)
			on_ground = true
			fall()
			calculate_knockback(area)
			await(get_tree().create_timer(5).timeout)
			on_ground = false
		else:
			queue_free()
	
	if area.name == "player_hitbox":
		get_tree().call_group("player","hurt",damage)
		on_ground = true
		fall()
		calculate_knockback(area)
		await(get_tree().create_timer(5).timeout)
		on_ground = false


func fall():
	$uped.hide()
	$falled.show()
	$hitbox.PROCESS_MODE_DISABLED
	await(get_tree().create_timer(5).timeout)
	$uped.show()
	$falled.hide()
	$hitbox.process_mode


func knockback(force: Vector3, impact_point: Vector3):
	velocity = force.limit_length(15.0)


func calculate_knockback(area: Area3D):
	var body_collision = (global_position - area.global_position)
	body_collision.y = 0.0
	var force = body_collision
	force = force * 2.0
	knockback(force, body_collision)
	await(get_tree().create_timer(.3).timeout)
	velocity = velocity * 0
