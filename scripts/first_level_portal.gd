extends Area3D

@export var portal_type: portal_types
enum portal_types {ENTER, EXIT}
@export var portal_closed: bool = false
var player_near: bool = false

func _ready() -> void:
	if portal_type == portal_types.EXIT:
		SignalBus.on_boss_defeated.connect(open_exit_portal)
		portal_closed = true

func _on_body_entered(body: Node3D) -> void:
	if body.name == "player":
		player_near = true

func _on_body_exited(body: Node3D) -> void:
	if body.name == "player":
		player_near = false

func open_exit_portal() -> void:
	portal_closed = false

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact") and player_near:
		print("clicking")
		if Global.current_world == Global.worlds.NORMAL:
			Global.player_can_attack = true
			Global.current_world = Global.worlds.FIRST_LEVEL
			Global.player_first_level_pos = Vector3(1.3,2.7,40.5)
			print("teleportando..")
			Global.next_scene = "res://scenes/worlds/first_level.tscn"
			get_tree().change_scene_to_packed(Global.loading_screen)
		elif Global.current_world == Global.worlds.FIRST_LEVEL and !portal_closed:
			Global.completed_levels["first_level"] = true
			SaveLoad.save_content[Global.current_save]["completed_levels"]["first_level"] = true
			Global.player_can_attack = true
			Global.player_normal_pos = Vector3(90,2,113)
			Global.current_world = Global.worlds.NORMAL
			Global.next_scene = "res://scenes/worlds/normal_world.tscn"
			get_tree().change_scene_to_packed(Global.loading_screen)
