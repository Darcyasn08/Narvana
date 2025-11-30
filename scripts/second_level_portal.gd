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
	if Input.is_action_just_pressed("interact") and player_near and !portal_closed:
		if Global.current_world == Global.worlds.NORMAL:
			Global.current_world = Global.worlds.SECOND_LEVEL
			#Global.player_first_level_pos = Vector3(1.3,2.7,40.5)
			Global.next_scene = "res://scenes/worlds/second_level.tscn"
			get_tree().change_scene_to_packed(Global.loading_screen)
		elif Global.current_world == Global.worlds.SECOND_LEVEL and !portal_closed:
			if portal_type == portal_types.EXIT:
				Global.completed_levels["second_level"] = true
			#Global.last_saved_pos = Vector3(13,1,30)
			Global.current_world = Global.worlds.NORMAL
			Global.last_saved_pos = Vector3(14,1,29)
			Global.next_scene = "res://scenes/worlds/normal_world.tscn"
			get_tree().change_scene_to_packed(Global.loading_screen)
