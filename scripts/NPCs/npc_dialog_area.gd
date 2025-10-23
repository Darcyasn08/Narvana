extends Area3D

@export_category("Npc")
@export var npc_manager: Node3D
var npc_name: String = ""
@export var area_collision: CollisionShape3D

var player_near: bool = false
var player: CharacterBody3D = null

func _physics_process(_delta: float) -> void:
	if player != null and get_parent().get_node_or_null("npc_interact_sign") != null:
		get_parent().get_node("npc_interact_sign").look_at(player.get_node("camera_pivot/SpringArm3D/Camera3D").global_position)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("e"):
		activate_dialogue()

func get_npc_data() -> void:
	if npc_manager == null:
		print("ops, não tem node3d aqui, arruma depois isso hein")
	else:
		npc_name = npc_manager.current_npc
		SignalBus.on_dialog_activated.emit(npc_name)

func _on_body_entered(body: Node3D) -> void:
	if body.name == "player":
		print("player entrou")
		if get_parent().get_node("npc_interact_sign"):
			get_parent().get_node("npc_interact_sign").show()
		player_near = true
		player = body
		print(player)

func _on_body_exited(body: Node3D) -> void:
	if body.name == "player":
		player_near = false
		if get_parent().get_node("npc_interact_sign"):
			get_parent().get_node("npc_interact_sign").hide()
		player = null
		SignalBus.on_dialog_area_leave.emit()

func activate_dialogue() -> void:
	if player_near:
		get_npc_data()
