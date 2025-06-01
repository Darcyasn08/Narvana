extends Area3D

var player_near: bool = false


func _physics_process(delta: float) -> void:
	activate_dialogue()

func _on_body_entered(body: Node3D) -> void:
	if body.name == "player":
		player_near = true
		get_parent().get_node("name_label").show()

func _on_body_exited(body: Node3D) -> void:
	if body.name == "player":
		player_near = false
		get_parent().get_node("name_label").hide()

func activate_dialogue():
	if player_near and Input.is_action_just_pressed("e"):
		SignalBus.on_dialogue_activated.emit(get_parent().npc_name)
