class_name Enemies extends Node3D

func add_health(health):
	health += 1
	print("on class: ",health)
	return

func _physics_process(delta: float) -> void:
	add_health(1)


#func take_damage(area,life,global_position,velocity,node):
	#if area.is_in_group("weapon"):
		#if life > Global.player_damage:
			#life -= Global.player_damage
			#print(life)
			#calculate_knockback(area,global_position,velocity,node)
		#else: #quando ele morre
			#SignalBus.on_enemy_death.emit()
			#node.queue_free()
			#
#func knockback(force: Vector3, impact_point: Vector3, velocity):
	#velocity = force.limit_length(15.0)
#
#
#func calculate_knockback(area: Area3D, global_position, velocity, node):
	#var body_collision = (global_position - area.global_position)
	#body_collision.y = 0.0
	#var force = body_collision
	#knockback(force, body_collision, velocity)
	#await(node.create_timer(.3).timeout)
	#velocity = velocity * 0
