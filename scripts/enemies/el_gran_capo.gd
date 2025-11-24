extends CharacterBody3D


var life: int = 7000
var damage: int = 1
var bullet_speed: float = 5.0
var state : String = "bubble"
var speed : float = 3.0
var acceleration : float = 15.0
var spaw_point : Vector3
var player_near : bool = false
var target_life : int 
var beatable : bool = true
var old_state : String
var target_angle : float
var old_velocity : Vector3
var swirl_hits : int = 0

var bubbleins: Object = preload("res://scenes/weapon/projectile.tscn")
var original_resource: StandardMaterial3D = load("res://shaders/el_gran_capo_skin.tres")
var unique_resource: Object = original_resource.duplicate()
@onready var body_path = $gran_capo_model/grancapo/Armature/Skeleton3D/Sphere/"surface_material_override/0"

@onready var player: CharacterBody3D = $"../player"

func _ready() -> void:
	print(typeof(body_path))
	unique_resource.albedo_color = Color("b67253ff")
	body_path = null
	body_path = unique_resource
	spaw_point = global_position
	SignalBus.on_narval_next_to_wall.connect(narval_smasher)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if state == "bubble" or state == "swirl" or state == "beating":
		look_to_player()
	
	if state == "swirl" or state == "beating":
		if player_near == false:
			rotation.x = 0
			var forward := global_basis.z #determina oq é a frente 
			var move_direction := forward 
			move_direction.y = 0.0 #reseta o de y, pq ele não muda na hora de mover
			move_direction = move_direction.normalized() #nao sei oq isso faz
			velocity = velocity.move_toward(move_direction * -speed, acceleration * delta) #move pra frente
			velocity.y = 0
	
	if state == "swirl" and player_near:
		state = "swirl2"
		velocity = Vector3.ZERO
		target_life = life - 700
		$enemy_hitbox/swirl.disabled = false
		$enemy_hitbox/hitbox.disabled = true
		#$collision.disabled = true
		$gran_capo_model.set_state("start_circling")
		await get_tree().create_timer(1.2).timeout
		$swirl_col.disabled = false
		$gran_capo_model.set_state("big_circling")
		$Timer.wait_time = 9.0
		$Timer.start()
	
	if state == "beating" and player_near:
		activate_smash()
		
	if state == "beating2" :
		global_rotation.y = lerp_angle(global_rotation.y,target_angle,acceleration/6 * delta)
	
	if state == "swirl2" and life < target_life:
		cancel_swirl()
	move_and_slide()

func damage_player(area)-> void:
	if state == "swirl2" or state == "beating2":
		get_tree().call_group("player","hurt",damage)

func unique_take_damage(area)-> void:
	body_path = unique_resource

func unique_die()-> void:
	Global.completed_levels["second_level"] = true
	SignalBus.on_ignite_cutscene.emit("final")

func look_to_player()-> void:
	var pos2d: Vector2 = Vector2(global_position.x, global_position.z)
	var targetpos2d: Vector2 = Vector2(player.global_position.x, player.global_position.z)
	var target_angle: Vector2 = pos2d - targetpos2d
	global_rotation.y = lerp_angle(rotation.y,atan2(target_angle.x, target_angle.y), .1)

func _on_timer_timeout() -> void:
	if state == "bubble":
		beatable = false 
		await(get_tree().create_timer(3).timeout)
		shoot()
		await(get_tree().create_timer(3).timeout)
		state = "swirl"
		#$Timer.wait_time = 2.0
		#$Timer.start()
	elif state == "swirl2" and swirl_hits < 3 and player_near:
		get_tree().call_group("player","hurt",damage)
		swirl_hits += 1
		$Timer.wait_time = 1.5
		$Timer.start()
		
	elif state == "swirl2" or state == "between":
		cancel_swirl()


func shoot() -> void:
	var bubble = bubbleins.instantiate()
	bubble.pos = $shooter.global_position
	bubble.rot = rotation
	bubble.follow = false
	bubble.model = "res://scenes/weapon/bubble_grancapo.tscn"
	bubble.speed = bullet_speed
	bubble.damage = damage
	bubble.size = 7.0
	get_parent().add_child(bubble)


func _on_player_detection_area_entered(area: Area3D) -> void:
	if area.name == "player_hitbox":
		player_near = true

func _on_player_detection_area_exited(area: Area3D) -> void:
	if area.name == "player_hitbox":
		player_near = false


func cancel_swirl() -> void:
	if state == "between":
		state = "bubble"
		beatable = true
	elif state == "swirl2":
		state = "between"
	$enemy_hitbox/swirl.disabled = true
	$enemy_hitbox/hitbox.disabled = false
	#$collision.disabled = true
	$swirl_col.disabled = true
	$gran_capo_model.set_state("idle")
	$enemy_hitbox/swirl.scale = Vector3(1.098,1.098,1.098)
	$Timer.wait_time = 2.0
	$Timer.start()

func narval_smasher() -> void:
	if beatable :
		beatable = false
		old_state = state
		old_velocity = velocity
		state = "beating"
		$Timer.stop()
		
func activate_smash() -> void:
	target_angle = deg_to_rad(rad_to_deg(global_rotation.y) + 180)
	state = "beating2"
	await(get_tree().create_timer(2).timeout)
	state = old_state
	velocity =  old_velocity
	$Timer.start()
