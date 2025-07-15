extends CharacterBody3D

var speed := 4.0
var life := 500
var damage := 1
var acceleration := 15.0
var imovel := true

@export var modelo_de_movel: Node3D

@onready var player = $"../player"

func _ready() -> void:
	await(get_tree().create_timer(5).timeout)
	imovel = false
	
func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	if !imovel:
		look_to_player()#muda a rotação do bixo pra ficar de frente com o player
		rotation.x = 0
		var forward := global_basis.z #determina oq é a frente 
		var move_direction := forward 
		move_direction.y = 0.0 #reseta o de y, pq ele não muda na hora de mover
		move_direction = move_direction.normalized() #nao sei oq isso faz
		velocity = velocity.move_toward(move_direction * -speed, acceleration * delta) #move pra frente
		velocity.y = 0
	move_and_slide()

func damage_player(area):
	get_tree().call_group("player","hurt",damage)

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
	

func unique_die():
	pass

func look_to_player():
	var pos2d: Vector2 = Vector2(global_position.x, global_position.z)
	var targetpos2d: Vector2 = Vector2(player.global_position.x, player.global_position.z)
	var target_angle = pos2d - targetpos2d
	global_rotation.y = lerp_angle(rotation.y,atan2(target_angle.x, target_angle.y),.1)
