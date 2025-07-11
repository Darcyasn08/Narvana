extends CharacterBody3D

var life: int = 5000
var damage: int = 1
var bullet_inst = preload("res://scenes/projectile.tscn")
var bullet_speed: float = 35.0
var saidas_disponiveis := []
var state := "shooting"
var knocker := 0
var player_near: bool = false
#eu te amo :)

@onready var player = $"../player"

func _ready() -> void:
	#inicializar_lista()
	life = Global.house_health


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("space") and player_near:
		Global.house_health = life
		print("ovo cuzido")
		Global.player_health = player.health
		get_tree().change_scene_to_file("res://scenes/inside_house.tscn")
	

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	if state == "shooting" and $walls_holder.position.y < -0.2:
		$walls_holder.position.y += 0.03
	if state == "death_ray" and $walls_holder.position.y > -8:
		$walls_holder.position.y -= 0.03
	if state == "death_ray":
		look_to_player(delta)
		#look_to_player()
		if life < knocker:
			state = "knocked"
			print("ovo cuzuuudo")
			$door/door_collision.disabled = false
			$holo_holder/laser_area/hurtbox.disabled = true
			$holo_holder/laser_holofote.hide()
			$holo_holder.hide()
			knocker = 0
			$Timer.wait_time = 10
			$Timer.start()
			
	move_and_slide()
	$holo_holder.move_and_slide()
func inicializar_lista() -> void:
	saidas_disponiveis.clear()
	for i in range(1, 10):
		saidas_disponiveis.append(i)
		

func sorteia_numero() -> void:
	if saidas_disponiveis.is_empty(): # detecta se todos os numeros ja foram para 
		print("Todos os números já foram sorteados.")
		
	else: 
		var indice := randi() % saidas_disponiveis.size()
		var saida_sorteada : int 
		saida_sorteada = saidas_disponiveis[indice]
		saidas_disponiveis.remove_at(indice) #tira o numero ja sorteado da lista
		shoot(saida_sorteada)
		await(get_tree().create_timer(1).timeout)
		
		

func shoot(saida: int):
	var node = get_node("walls_holder/saidas/exit"+str(saida))
	var laser = get_node("walls_holder/saidas/exit"+str(saida)+"/laser")
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
	

func look_to_player(delta):
	var pos2d: Vector2 = Vector2(global_position.x, global_position.z)
	var targetpos2d: Vector2 = Vector2(player.global_position.x, player.global_position.z)
	var target_angle = -(pos2d - targetpos2d)
	$holo_holder.rotation.y = lerp_angle($holo_holder.rotation.y,atan2(target_angle.x, target_angle.y),delta / 2)
	#print(atan2(target_angle.x, target_angle.y))
	#print($holo_holder.rotation.y)
	var pos2d2 = Vector2($holo_holder.global_position.y, $holo_holder.global_position.z)
	var targetpos2d2 = Vector2(player.global_position.y, player.global_position.z)
	var target_angle2 = -(pos2d2 - targetpos2d2)
	$holo_holder.global_rotation.x = lerp_angle($holo_holder.rotation.x,-(atan2(target_angle2.x, target_angle2.y)),delta / 2)
	print(atan2(target_angle2.x, target_angle2.y))
	print($holo_holder.rotation.x)
	
func _on_timer_timeout() -> void:
	if state == "shooting":
		inicializar_lista()
		for i in range(1,10):
			sorteia_numero()
			await(get_tree().create_timer(0.5).timeout)
		await(get_tree().create_timer(3).timeout)
		state = "death_ray"
		$Timer.start()
	if state == "death_ray":
		$holo_holder.show()
		await(get_tree().create_timer(3).timeout)
		knocker = life - 500
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
			
	if state == "knocked":
		state = "shooting"
		$Timer.wait_time = 1
		$Timer.start()
		
		
			


func _on_laser_area_area_entered(area: Area3D) -> void:
	if area.name == "player_hitbox":
		get_tree().call_group("player","hurt",damage)
		
func unique_take_damage(area):
	pass
	

func unique_die():
	pass

func damage_player(area):
	pass


func _on_door_area_entered(area: Area3D) -> void:
	if area.name == "player_hitbox":
		player_near = true


func _on_door_area_exited(area: Area3D) -> void:
	if area.name == "player_hitbox":
		player_near = false
