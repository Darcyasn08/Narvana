extends CharacterBody3D

var life: int = 8000
var damage: int = 1
var bullet_speed: float = 20.0
var state: String = "storm"
var screaming: bool = false
var elevating: bool = false
var in_sequence : bool = false
var hit_count: int = 0
var distile: Array = []
var enemies_count: int = 0
var round: int = 0
var shoots_count: int = 0


var raioins: Object = preload("res://scenes/enemies/meteor.tscn")
var bulletins: Object = preload("res://scenes/projectile.tscn")

var player_path: String = "player"
@onready var player: CharacterBody3D = get_node(player_path)

func _ready() -> void:
	while player == null:
		player_path = "../"+player_path
		player = get_node(player_path)
	SignalBus.on_round_over.connect(rounds)
func _physics_process(delta: float) -> void:
	
	if elevating and state == "battle":
		$floor_holder.position.y += 0.2
	if elevating and state == "shooting":
		$floor_holder.position.y -= 0.2
	if screaming:
		$scream_wall.position.z += 0.4
	if state == "shooting":
		$shooter_looker.look_at(player.global_position)

func unique_take_damage(area) -> void:
	if !in_sequence:
		start_sequence()
	elif in_sequence and hit_count < 6:
		hit_count += 1	
	if in_sequence and hit_count >= 6:
		#animçaõ dele gritando pequeno
		%master_tiny_model.set_state("tiny_scream")
		await(get_tree().create_timer(.75).timeout)#tempo da animção dele gritando grande
		scream()


func unique_die() -> void:
	await get_tree().create_timer(1).timeout
	get_tree().paused = true
	SignalBus.on_ignite_cutscene.emit("final")
	
func damage_player(_area) -> void:
	pass


func _on_timer_timeout() -> void:
	if state == "storm":
		await storm_rain()
		state = "battle"
		$Timer.wait_time = 2.0
		$Timer.start()
	elif state == "battle":
		await battle_start()
		rounds()
	elif state == "shooting":
		if shoots_count < 7:
			%master_tiny_model.set_state("firing")
			shoots()
		else:
			shoots_count = 0
			state = "storm"
			$enemy_hitbox/hitbox.disabled = true
			$collision.disabled = true
			$Timer.wait_time = 2.0
			$Timer.start()


func storm_rain() -> void:
	#animação dele invocando a chuva
	%master_model_ani.set_state("thunder_attack")
	await(get_tree().create_timer(1.25).timeout)#tempo da animção
	%master_model_ani.set_state("idle")
	for j in 3:
		for i in 15:
			var raio = raioins.instantiate()
			raio.pos.y = $floor_holder.position.y + .5
			raio.pos.z = randf_range( -17, 17 )
			raio.pos.x = randf_range(-17,17)
			raio.damage = damage
			raio.speed = 0.6
			raio.time = 2.0
			raio.molde = "res://3d_models/enemies/thunder_model.glb"
			raio.escale = Vector3(0.5,0.5,0.5)
			add_child(raio)
		await(get_tree().create_timer(2.0).timeout)

func battle_start() -> void:
	#animaçao dele circulando em loop
	distile.clear()
	for i in range(1, 10):#sim, são 9 saidas não tem nada de errado
		distile.append(i)
	elevating = true
	player.jump_impulse = 0.0
	await(get_tree().create_timer(2.0).timeout)
	elevating = false
	await(get_tree().create_timer(.1).timeout)
	player.jump_impulse = 12.0
	$grand_dust/dust_area.disabled = false
	$floor_holder/manager/arena.disabled = false
	
func scream() -> void:
	in_sequence = false
	hit_count = 0
	screaming = true
	await get_tree().create_timer(1.5).timeout
	screaming = false
	$scream_wall.position.z = 0.0
	
	
func start_sequence() -> void:
	in_sequence = true
	hit_count += 1
	await get_tree().create_timer(7).timeout
	in_sequence = false
	hit_count = 0

func sorteia_numero() -> void:
	if distile.is_empty(): # detecta se todos os numeros ja foram para 
		pass
		print("Todos os números já foram sorteados.")
	else: 
		var indice :int = randi() % distile.size() # sorteia um numero aleatório da lista
		if indice == 0:
			sorteia_numero()
			return
		var tile_sorteada : int 
		tile_sorteada = distile[indice]
		distile.remove_at(indice) #tira o numero ja sorteado da lista
		tile_disapear(indice)
		await(get_tree().create_timer(1).timeout)

func tile_disapear(number : int) -> void:
	var tile : CollisionShape3D = get_node("floor_holder/tile"+str(number))
	var moldet : MeshInstance3D = get_node("floor_holder/tile_mold"+str(number))
	moldet.hide()
	await(get_tree().create_timer(.4).timeout)
	moldet.show()
	await(get_tree().create_timer(.4).timeout)
	moldet.hide()
	await(get_tree().create_timer(.4).timeout)
	moldet.show()
	await(get_tree().create_timer(.4).timeout)
	moldet.hide()
	await(get_tree().create_timer(.2).timeout)# troca tudo isso por uma animçao desaparecendo 
	tile.disabled = true



func rounds() -> void:
	if round < 3: # < 3
		sorteia_numero()
		await(get_tree().create_timer(2).timeout)
		for i in range(1,4):
			var catch_enemy: String = Global.enemies[0][randi_range(0,3)]
			var enemy_path: Object = load(catch_enemy)
			var enemy: Object = enemy_path.instantiate()
			enemy.global_position = Vector3(randf_range(global_position.x-18,global_position.x + 18),$floor_holder.position.y + 3,randf_range(global_position.z -18,global_position.z + 18))
			get_parent().add_child(enemy)
		round +=1
	elif round == 3: # == 3
		for i in range(1,10):
			var tile : CollisionShape3D = get_node("floor_holder/tile"+str(i))
			var moldet : MeshInstance3D = get_node("floor_holder/tile_mold"+str(i))
			moldet.show()
			tile.disabled = false
		state = "shooting"
		$floor_holder/manager/arena.disabled = true
		$grand_dust/dust_area.disabled = true
		elevating = true
		%master_tiny_model.show()
		await(get_tree().create_timer(2.0).timeout)
		elevating = false
		$collision.disabled = false
		$enemy_hitbox/hitbox.disabled = false
		#animaçao dele gritando grande
		%master_model_ani.set_state("scream_attack")
		scream()
		await(get_tree().create_timer(1.25).timeout)#tempo da animção dele gritando grande
		#animção dele diminuindo
		%master_model_ani.set_state("getting_tiny")
		$Timer.wait_time = 1.0
		$Timer.start()
		
		
func shoots() -> void:
	for b in 4:
		var bullet = bulletins.instantiate()
		bullet.pos = $shooter_looker/shooter.global_position
		bullet.rot = $shooter_looker.rotation
		bullet.follow = false
		bullet.speed = bullet_speed
		bullet.damage = damage
		#futuramente determinar o molde do projetil
		get_parent().add_child(bullet)
		await(get_tree().create_timer(.2).timeout)
		#animação do mini mestre atirando
	shoots_count += 1
	$Timer.wait_time = 3.0
	$Timer.start()


func _on_grand_dust_area_entered(area: Area3D) -> void:
	if area.name == "player_hitbox":
		get_tree().call_group("player","hurt",40)


func _on_manager_area_entered(area: Area3D) -> void:
	print(enemies_count)
	if area.name =="player_hitbox":
		pass
	if area.is_in_group("enemies"):
		enemies_count += 1


func _on_manager_area_exited(area: Area3D) -> void:
	if area.name == "player_hitbox":
		pass
	if area.is_in_group("enemies"):
		if enemies_count == 1:
			await(get_tree().create_timer(.2).timeout)
			enemies_count -= 1
			if enemies_count > 0:
				pass
			else:
				SignalBus.on_round_over.emit()
		if enemies_count > 1:
			enemies_count -= 1
