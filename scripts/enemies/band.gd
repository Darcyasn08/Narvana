extends Node3D

var life: int = 5000
var damage: int = 1
var state: String = "turtle_turn"
var cur_member: CharacterBody3D
var turtle_state: String 
var horse_state: String
var level: int = 1
var speed : float = 3.0
var acceleration : float = 15.0
var horse_place : Vector3
var jump_impulse: float = 12.0
var horse_exploded: bool = false

var holofoteins: Object = preload("res://scenes/enemies/meteor.tscn")

@onready var horse : CharacterBody3D = $sea_horse
@onready var turtle: CharacterBody3D = $turtle
@onready var octopus: CharacterBody3D = $octopus
@onready var player: CharacterBody3D = $"../player"

func _ready() -> void:
	cur_member = $turtle

func _physics_process(delta: float) -> void:
	if not horse.is_on_floor():
		horse.velocity += horse.get_gravity() * delta
	if not turtle.is_on_floor():
		turtle.velocity += turtle.get_gravity() * delta
	if not octopus.is_on_floor():
		octopus.velocity += octopus.get_gravity() * delta
		
	if turtle_state == "spinning":
		look_to_player()
	if turtle_state == "spinning"  or state == "dying":
		turtle.rotation.x = 0
		var forward: Vector3 = turtle.global_basis.z #determina oq é a frente 
		var move_direction := forward 
		move_direction.y = 0.0 #reseta o de y, pq ele não muda na hora de mover
		move_direction = move_direction.normalized() #nao sei oq isso faz
		turtle.velocity = turtle.velocity.move_toward(move_direction * (-speed) , acceleration * delta) #move pra frente
		turtle.velocity.y = 0
	if horse_state == "running" or state == "dying":
		horse.rotation.x = 0
		var forward := horse.global_basis.z #determina oq é a frente 
		var move_direction := forward 
		move_direction.y = 0.0 #reseta o de y, pq ele não muda na hora de mover
		move_direction = move_direction.normalized() #nao sei oq isso faz
		horse.velocity = horse.velocity.move_toward(move_direction * (-speed*4) , acceleration * delta)
		if horse.global_position.x < $warning.global_position.x + 1 and  horse.global_position.x > $warning.global_position.x - 1 and  horse.global_position.z < $warning.global_position.z + 1 and horse.global_position.z > $warning.global_position.z - 1:
			horse.get_node("seahorse_model").set_state("attack-explosion")
			await(get_tree().create_timer(.3).timeout)
			horse_state = "exploding"
			horse.velocity = Vector3.ZERO
			$sea_horse/guitar_explosion/explosion.disabled = false
			$warning.hide()
			await(get_tree().create_timer(2).timeout)
			$sea_horse/guitar_explosion/explosion.disabled = true
			await(get_tree().create_timer(1).timeout)
			horse.look_at(horse_place)
			$warning.global_position = horse_place
			horse_state = "running"
			horse.get_node("seahorse_model").set_state("idle")
		if horse.global_position.x < $warning.global_position.x + 1 and  horse.global_position.x > $warning.global_position.x - 1 and  horse.global_position.z < $warning.global_position.z + 1 and horse.global_position.z > $warning.global_position.z - 1 and horse_exploded :
			horse_state = ""
			horse.velocity = Vector3.ZERO
			horse.get_node("seahorse_model").set_state("idle")
	octopus.move_and_slide()
	turtle.move_and_slide()
	horse.move_and_slide()

func damage_player(area)-> void:
	pass

func knockback(force: Vector3, impact_point: Vector3)-> void:
	if cur_member != null:
		cur_member.velocity = force.limit_length(10.0)

func calculate_knockback(area: Area3D)-> void:
	var body_collision = (global_position - area.global_position)
	body_collision.y = 0.0
	var force = body_collision
	knockback(force, body_collision)
	await(get_tree().create_timer(.2).timeout)
	cur_member.velocity = cur_member.velocity * 0

func unique_take_damage(area)-> void:
	pass

func unique_die()-> void:
	state = "dying"
	turtle.look_at(octopus.global_position)
	horse.look_at(octopus.global_position)
	await(get_tree().create_timer(3).timeout)

func look_to_player()-> void:
	var pos2d: Vector2 = Vector2(cur_member.global_position.x, cur_member.global_position.z)
	var targetpos2d: Vector2 = Vector2(player.global_position.x, player.global_position.z)
	var target_angle = pos2d - targetpos2d
	cur_member.global_rotation.y = lerp_angle(cur_member.rotation.y,atan2(target_angle.x, target_angle.y), .1)


func _on_timer_timeout() -> void:
	if state == "turtle_turn":
		await turtle_attack()
		state = "horse_turn"
		$Timer.wait_time = 2.0
		$Timer.start()
	elif state == "horse_turn":
		horse_attack()
		state = "octopus_turn"
		$Timer.wait_time = 10.0
		$Timer.start()
	elif state == "octopus_turn":
		await oct_attack()
		state = "turtle_turn"
		$Timer.wait_time = 2.0
		$Timer.start()


func _on_guitar_explosion_area_entered(area: Area3D) -> void:
	if area.name == "player_hitbox":
		get_tree().call_group("player","hurt",damage)

func turtle_attack() -> void:
	$turtle/enemy_hitbox/hitbox.disabled = false
	cur_member = $turtle
	turtle_state = "spinning"
	turtle.get_node("turtle_model").set_state("pre-attack")
	await(get_tree().create_timer(.7).timeout)
	turtle.get_node("turtle_model").set_state("attack")
	await(get_tree().create_timer(10).timeout)
	turtle_state = "knocked"
	#colocar a futura animação de knocked aqui
	turtle.get_node("turtle_model").set_state("idle")
	turtle.velocity = Vector3(0,0,0)
	await(get_tree().create_timer(5).timeout)
	$turtle/enemy_hitbox/hitbox.disabled = true

func horse_attack() -> void:
	horse_place = horse.global_position
	var target : Vector3 = player.global_position
	horse.get_node("seahorse_model").set_state("pre-attack")
	horse.look_at(target)
	$warning.global_position = player.global_position
	$warning.show()
	await(get_tree().create_timer(.5).timeout)
	horse_state = "running"
	horse.get_node("seahorse_model").set_state("attack-loop")

func oct_attack() -> void :
	#animaçao do polvo batendo na bateria
	for i:int in 8:
		var holofote = holofoteins.instantiate()
		holofote.pos.y = $octopus.global_position.y
		holofote.pos.z = randf_range( $octopus.position.z - 1.5 , $octopus.position.z - 20 )
		holofote.pos.x = randf_range( $octopus.position.x - 10, $octopus.position.x + 10 )
		holofote.damage = damage
		holofote.time = 2.0
		add_child(holofote)

func _on_enemy_hitbox_area_entered(area: Area3D) -> void:
	if turtle_state == "spinning" and area.name == "player_hitbox":
		get_tree().call_group("player","hurt",damage)
		turtle_state = "knocked"
		turtle.velocity = Vector3(0,0,0)
	calculate_knockback(area)
