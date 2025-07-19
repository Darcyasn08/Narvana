extends Area3D

@export_category("Npc")
@export var npc_manager: Node3D
var npc_name: String = ""
@export var area_collision: CollisionShape3D

var player_near: bool = false

func _physics_process(_delta: float) -> void:
	activate_dialogue()

func get_npc_data() -> void:
	if npc_manager == null:
		print("ops, não tem node3d aqui, arruma depois isso hein")
	else:
		npc_name = npc_manager.current_npc
		#print(npc_name)
		print("dialog ignited")
		SignalBus.on_dialog_activated.emit(npc_name)

func _on_body_entered(body: Node3D) -> void:
	if body.name == "player":
		print("player entrou")
		player_near = true

func _on_body_exited(body: Node3D) -> void:
	if body.name == "player":
		player_near = false
		SignalBus.on_dialog_area_leave.emit()

func activate_dialogue() -> void:
	if player_near and Input.is_action_just_pressed("e"):
		get_npc_data()
