extends Node3D

var life: int = 400
var damage: int = 1
var cur_parent : CharacterBody3D
var state: String = "dads_turn"
var dad_state: String 
var level: int = 2
var dadshs: int = 0 #tendeu? dad + dashs = dadshs kkkkkkkkkkkk
var speed : float = 3.0
var acceleration : float = 15.0

var pieins = preload("res://scenes/enemies/pie.tscn")

@onready var mom: CharacterBody3D = $mom
@onready var dad: CharacterBody3D = $dad
@onready var player = $"../player"


func _ready() -> void:
	if level == 2:
		state = "both"

func _physics_process(delta: float) -> void:
	if not mom.is_on_floor():
		mom.velocity += mom.get_gravity() * delta
	if not dad.is_on_floor():
		dad.velocity += dad.get_gravity() * delta
		
	if dad_state == "aimming" or dad_state == "smashing":
		look_to_player()
	if dad_state == "dadshing" or dad_state == "smashing":
		dad.rotation.x = 0
		var forward := dad.global_basis.z #determina oq é a frente 
		var move_direction := forward 
		move_direction.y = 0.0 #reseta o de y, pq ele não muda na hora de mover
		move_direction = move_direction.normalized() #nao sei oq isso faz
		dad.velocity = dad.velocity.move_toward(move_direction * (-speed*5) , acceleration * delta) #move pra frente
		dad.velocity.y = 0
	if state == "moms_turn" or state =="both":
		mom.look_at(player.global_position)
	mom.move_and_slide()
	dad.move_and_slide()
	
	
func damage_player(area)-> void:
	pass
	

func knockback(force: Vector3, impact_point: Vector3)-> void:
	cur_parent.velocity = force.limit_length(15.0)


func calculate_knockback(area: Area3D)-> void:
	var body_collision = (global_position - area.global_position)
	body_collision.y = 0.0
	var force = body_collision
	force = force * Global.knock_multi
	knockback(force, body_collision)
	await(get_tree().create_timer(.3).timeout)
	cur_parent.velocity = cur_parent.velocity * 0

func unique_take_damage(area)-> void:
	print(life)
	calculate_knockback(area)
	
func unique_die()-> void:
	pass

func look_to_player()-> void:
	var pos2d: Vector2 = Vector2(cur_parent.global_position.x, cur_parent.global_position.z)
	var targetpos2d: Vector2 = Vector2(player.global_position.x, player.global_position.z)
	var target_angle = pos2d - targetpos2d
	cur_parent.global_rotation.y = lerp_angle(cur_parent.rotation.y,atan2(target_angle.x, target_angle.y), .1)


func _on_timer_timeout() -> void:
	if state == "dads_turn" :
		await dads_dash()
		get_lombar_pain()
		state = "moms_turn"
		$Timer.wait_time = 1.0
		$Timer.start()
	elif state == "moms_turn":
		await moms_cooking()
		get_lombar_pain()
		state = "dads_turn"
		$Timer.wait_time = 1.0
		$Timer.start()
	elif state == "both":
		dads_dash()
		moms_cooking()
		state = "both2"
		$Timer.wait_time = 20.0
		$Timer.start()
	elif state == "both2":
		await mega_attack()
		state = "both"
		$Timer.wait_time = 1.0
		$Timer.start()
func spaw_pie() -> void:
	#Animação: summon das tortas da mãe
	%mommy_model.set_state("bodyAction")
	await(get_tree().create_timer(1).timeout)
	var pie = pieins.instantiate()
	pie.global_position = $mom/pie_spawner.global_position
	pie.rotation = $mom/pie_spawner.global_rotation
	get_parent().add_child(pie)
	%mommy_model.set_state_back("bodyAction")
	await(get_tree().create_timer(1).timeout)
	%mommy_model.set_state("mom_idle")
	
func get_lombar_pain() -> void:
	if  state == "moms_turn" or state == "both":
		$mom/escudo.show()#colocar a animação deles com escudo e dor nas costa
		$mom/enemy_hitbox/hitbox.disabled = true
	if state == "dads_turn":#aqui tbm
		$dad/enemy_hitbox/hitbox.disabled = true
		$dad/escudo.show()
		
func dads_dash() ->void:
	$dad/escudo.hide()
	$dad/enemy_hitbox/hitbox.disabled = false
	cur_parent = dad
	while dadshs < 3:
		dad_state = "aimming"#sei l se tem animaão dele mirando
		await(get_tree().create_timer(3).timeout)
		dad_state = "dadshing"#colocar animção dele girando
		%daddy_model.set_state("dad_tornado")
		await(get_tree().create_timer(2).timeout)
		#iddle
		dad_state = "aimming"
		dad.velocity = Vector3(0,0,0)
		dadshs += 1
	dadshs = 0
	dad_state = "" 
		
		
func moms_cooking() -> void:
	$mom/escudo.hide()
	$mom/enemy_hitbox/hitbox.disabled = false
	
	#colocar animçao dela conjrando a torta e adaptar os awaits pro tempo da animção
	spaw_pie()
	await(get_tree().create_timer(3).timeout)
	spaw_pie()
	await(get_tree().create_timer(3).timeout)
	spaw_pie()
	await(get_tree().create_timer(3).timeout)
	%mommy_model.set_state("mom_idle")
	
	if state == "moms_turn":
		get_lombar_pain()
		state = "dads_turn"
	


func _on_enemy_hitbox_area_entered(area: Area3D) -> void:
	if dad_state == "dadshing" and area.name == "player_hitbox":
		get_tree().call_group("player","hurt",damage)
		calculate_knockback(area)
	
func mega_attack() -> void:
	#colocar um await com o tempo da animção deles deles preparando ataque
	speed = speed/3
	#$dad/standing.scale = $dad/standing.scale * 2
	dad_state = "smashing"
	for i in 5:
		await(get_tree().create_timer(1).timeout)
		%daddy_model.set_state("dad_hammering")
		$dad/hands/slaping.disabled = true
		#uma mão batendo
		$dad/hands/hand2.disabled = false
		await(get_tree().create_timer(0.5).timeout)
		$dad/hands/hand2.disabled = true
		#outra mão batendo
		$dad/hands/hand1.disabled = false
		await(get_tree().create_timer(1).timeout)
		$dad/hands/hand1.disabled = true
		#tapão de duas mao
		$dad/hands/slaping.disabled = false
		await(get_tree().create_timer(1.56).timeout)
	$dad/hands/slaping.disabled = true
	dad_state = ""
	dad.velocity = Vector3.ZERO
	#$dad/standing.scale = $dad/standing.scale / 2
	%daddy_model.set_state("idle")
	await(get_tree().create_timer(0.5).timeout)

func _on_hands_area_entered(area: Area3D) -> void:
	if area.name == "player_hitbox":
		get_tree().call_group("player","hurt",damage)
		dad.velocity = Vector3.ZERO
