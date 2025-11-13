extends CharacterBody3D


var speed : float = 5.0
var life : int = 500
var damage : int = 1
var acceleration : float = 15.0
var exploding : bool = false

@onready var player = $"../player"
#@onready var enemy_inst = Enemies.new()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if  is_on_floor() and exploding == false:
		look_to_player(delta)#muda a rotação do bixo pra ficar de frente com o player
		rotation.x = 0
		var forward := global_basis.z #determina oq é a frente 
		var move_direction := forward 
		move_direction.y = 0.0 #reseta o de y, pq ele não muda na hora de mover
		move_direction = move_direction.normalized() #nao sei oq isso faz
		velocity = velocity.move_toward(move_direction * -speed, acceleration * delta) #move pra frente
		velocity.y = 0
	
	move_and_slide()

func look_to_player(delta : float) -> void:
	var pos2d: Vector2 = Vector2(global_position.x, global_position.z)
	var targetpos2d: Vector2 = Vector2(player.global_position.x, player.global_position.z)
	var target_angle = pos2d - targetpos2d
	global_rotation.y = lerp_angle(rotation.y,atan2(target_angle.x, target_angle.y),delta * 1.5)

func _on_hitbox_area_entered(area: Area3D) -> void:
	if area.name == "player_hitbox":
		explosion()
		
func explosion() -> void:
	velocity = Vector3(0,0,0)
	exploding = true
	$explosion_molde.show()
	$explosion_area.monitoring = true
	await(get_tree().create_timer(2).timeout)
	queue_free()


func _on_timer_timeout() -> void:
	explosion()


func _on_explosion_area_area_entered(area: Area3D) -> void:
	if area.name == "player_hitbox":
		get_tree().call_group("player","hurt",damage)
