extends CharacterBody3D

var life: int = 8000
var damage: int = 1
var bullet_inst: Object = preload("res://scenes/projectile.tscn")
var bullet_speed: float = 35.0
var saidas_disponiveis: Array = []
var state: String = "shooting"
var knocker: int = 0
var player_near: bool = false
var original_resource: Object = load("res://shaders/house_damage.tres")
var unique_resource: Object = original_resource.duplicate()

@onready var player: CharacterBody3D = $"../player"
@onready var walls_holder = $"house_model/walls_holder"

func _ready() -> void:
	life = Global.house_health #precisa disso pra quando voltar na cena dela por fora vai passar o dano por dentro
	$door/npc_interact_sign.player = player

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and player_near: #funcao de entrar na casa
		#print("e pressed")
		$fade_to_inside.show()
		$fade_to_inside/AnimationPlayer.play("fade_in")
		Global.house_health = life
		Global.player_health = player.health
		print(Global.player_health)
		await $fade_to_inside/AnimationPlayer.animation_finished
		get_tree().change_scene_to_file("res://scenes/enemies/inside_house.tscn")


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	if state == "shooting" and walls_holder.position.y < -0.2: # erque as paredes até certo ponto
		walls_holder.position.y += 0.03
	if state == "death_ray" and walls_holder.position.y > -8: #desce as paredes até certo ponto
		walls_holder.position.y -= 0.03
	if state == "death_ray": #ativa a funçao que faz o holofote olhar pro player todo frame
		look_to_player(delta) #essa aqui
		#look_to_player()
		if life < knocker: # funcao pra deixar ela nocauteada e abrira porta da casa
			state = "knocked"
			#print("IT IS ENABLED!!!")
			$door/door_collision.disabled = false
			$holo_holder/laser_area/hurtbox.disabled = true
			$door/door_closed.hide()
			$holo_holder/laser_holofote.hide()
			$holo_holder.hide()
			knocker = 0
			$Timer.wait_time = 10
			$Timer.start()
			
	move_and_slide()
	$holo_holder.move_and_slide() 


func inicializar_lista() -> void:
	saidas_disponiveis.clear() #faz umas lista de numeros aleatorios que vão ser as saidas na hora de atirar 
	for i in range(1, 10):#sim, são 9 saidas não tem nada de errado
		saidas_disponiveis.append(i)
		

func sorteia_numero() -> void:
	if saidas_disponiveis.is_empty(): # detecta se todos os numeros ja foram para 
		pass
		#print("Todos os números já foram sorteados.")
	else: 
		var indice := randi() % saidas_disponiveis.size() # sorteia um numero aleatório da lista
		var saida_sorteada : int 
		saida_sorteada = saidas_disponiveis[indice]
		saidas_disponiveis.remove_at(indice) #tira o numero ja sorteado da lista
		shoot(saida_sorteada)
		await(get_tree().create_timer(1).timeout)

func shoot(saida: int) -> void:
	var node = get_node("house_model/walls_holder/saidas/exit"+str(saida))
	var laser = get_node("house_model/walls_holder/saidas/exit"+str(saida)+"/laser")
	var bullet = bullet_inst.instantiate()
	bullet.pos = node.global_position
	bullet.rot = -node.global_rotation
	bullet.follow = false
	bullet.speed = -bullet_speed
	bullet.damage = damage
	#futuramente determinar o molde do projetil
	laser.show()
	await(get_tree().create_timer(2).timeout)
	get_parent().add_child(bullet)
	laser.hide()
	

func look_to_player(delta) -> void: #voce não quer tentar compreender essa funçao só deixa ela quieta e funcionando
	var pos2d: Vector2 = Vector2(global_position.x, global_position.z) 
	var targetpos2d: Vector2 = Vector2(player.global_position.x, player.global_position.z)
	var target_angle = -(pos2d - targetpos2d)
	$holo_holder.rotation.y = lerp_angle($holo_holder.rotation.y,atan2(target_angle.x, target_angle.y),delta / 2)
	var pos2d2 = Vector2($holo_holder.global_position.y, $holo_holder.global_position.z)
	var targetpos2d2 = Vector2(player.global_position.y, player.global_position.z)
	var target_angle2 = -(pos2d2 - targetpos2d2)
	$holo_holder.global_rotation.x = lerp_angle($holo_holder.rotation.x,-(atan2(target_angle2.x, target_angle2.y)),delta / 2)


func _on_timer_timeout() -> void:
	if state == "shooting": # coisas que serão feitas quando começar o ataque dos tiros das paredes
		$door/door_closed.show()
		inicializar_lista()
		for i in range(1,10):
			sorteia_numero()
			await(get_tree().create_timer(0.5).timeout)
		await(get_tree().create_timer(3).timeout)
		state = "death_ray"
		$Timer.wait_time = 5
		$Timer.start()
	if state == "death_ray": # coisas que serão feitas quando começar o ataque do holofote
		$door/door_closed.show()
		$holo_holder.show()
		await(get_tree().create_timer(3).timeout)
		knocker = life - 800
		$holo_holder/laser_holofote.show()
		$holo_holder/laser_area/hurtbox.disabled = false
		await(get_tree().create_timer(15).timeout)
		if state != "knocked": 
			$holo_holder/laser_area/hurtbox.disabled = true
			$holo_holder/laser_holofote.hide()
			$holo_holder.hide()
			knocker = 0
			await(get_tree().create_timer(2).timeout)
			state = "shooting"
			$Timer.wait_time = 5
			$Timer.start()
			
	if state == "knocked":# coisas que serão feitas quando fica nocauteada
		state = "shooting"
		$Timer.wait_time = 1
		$Timer.start()


func _on_laser_area_area_entered(area: Area3D) -> void:
	if area.name == "player_hitbox":
		get_tree().call_group("player","hurt",damage)


func unique_take_damage(area) -> void:
	print("damage")
	
	$house_model/house_model/Cube_001.material_overlay = unique_resource
	$house_model/house_model/Cube_001.material_overlay.albedo_color = Color("f599ccff")
	await get_tree().create_timer(.3).timeout
	$house_model/house_model/Cube_001.material_overlay.albedo_color = Color("#b1dee1")

func unique_die() -> void:
	$door.hide()
	$house_model/AnimationPlayer.play("death")
	await $house_model/AnimationPlayer.animation_finished
	SignalBus.on_boss_defeated.emit()

func damage_player(area) -> void:
	pass

func _on_door_area_entered(area: Area3D) -> void:
	if area.name == "player_hitbox":
		player_near = true
		$door/npc_interact_sign.show()

func _on_door_area_exited(area: Area3D) -> void:
	if area.name == "player_hitbox":
		player_near = false
		$door/npc_interact_sign.hide()
