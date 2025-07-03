extends Area3D

@onready var parent = get_parent()
@onready var life = parent.life

@export var hitbox_collision: CollisionShape3D

func _ready() -> void:
	pass

func _on_area_entered(area: Area3D) -> void:
	#print("AREAA!!")
	if area.is_in_group("weapon"):
		print("ive seen a weapon")
		take_damage(area)
	
	if area.name == "player_hitbox":
		take_damage_player(area)

func take_damage(area):
	if parent.life > Global.player_damage:
		parent.life -= Global.player_damage
		print(parent.life)
		parent.unique_take_damage(area)
	else: #quando ele morre
		await parent.unique_die()
		print("parent died")
		parent.queue_free()

func take_damage_player(area):
	parent.damage_player(area)
