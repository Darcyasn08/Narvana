extends Area3D

@onready var parent = get_parent()
@onready var life = parent.life

@export var hitbox_collision: CollisionShape3D

func _ready() -> void:
	parent.set_collision_layer_value(2, true)
	print("cu"+str(parent.collision_layer))
	parent.set_collision_mask_value(1, true)
	parent.set_collision_mask_value(2, true)

func _on_area_entered(area: Area3D, defense := 1.0) -> void:
	if area.is_in_group("weapon"):
		print("ouch, it hurts")
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


func take_damage(area, damage, defense := 1.0):
	if parent.life >int(round(damage * defense)):
		parent.life -= int(round(damage * defense))
		#print(int(round(damage * defense)))
		print(parent.life)
		parent.unique_take_damage(area)
	else: #quando ele morre
		await parent.unique_die()
		print("parent died")
		parent.queue_free()


func damage_player(area):
	parent.damage_player(area)
