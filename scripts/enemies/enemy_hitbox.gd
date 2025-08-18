extends Area3D

@onready var parent = get_parent()
@onready var life = parent.life
@onready var coin_inst: Object = preload("res://scenes/money.tscn")

@export var hitbox_collision: CollisionShape3D

func _ready() -> void:
	parent.set_collision_layer_value(2, true)
	parent.set_collision_mask_value(1, true)
	parent.set_collision_mask_value(2, true)

func _on_area_entered(area: Area3D, defense := 1.0) -> void:
	if area.is_in_group("weapon"):
		if parent.name == "car":
			if parent.state == "knocked":
				defense = 1
			else:
				defense = 0.75
		#print("ive seen a weapon")
		take_damage(area, Global.player_damage, defense)
	
	if area.name == "player_hitbox":
		damage_player(area)
		
	if area.is_in_group("damage_magic"):
		#print("ive seen a magic")
		take_damage(area, Global.dust_damage)


func take_damage(area, damage, defense := 1.0) -> void:
	if parent.life > int(round(damage * defense)):
		parent.life -= int(round(damage * defense))
		print(parent.life)
		#print("parent life: ",parent.life)
		parent.unique_take_damage(area)
	else: #quando ele morre
		#drop_coins(parent.enemy_min_coins, parent.enemy_max_coins)
		await parent.unique_die()
		print("parent died")
		await get_tree().create_timer(1).timeout
		parent.queue_free()


func damage_player(area) -> void:
	parent.damage_player(area)

#isso vai estar no enemy_hitbox

#func drop_coins(enemy_min_coins, enemy_max_coins) -> void:
	#var coin: Object = coin_inst.instantiate()
	#var coins: int = randi_range(enemy_min_coins, enemy_max_coins)
	#for i in range(coins):
		#print("coin is: ",coin)
		#add_child(coin)
