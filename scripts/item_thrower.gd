extends Node3D

var player_near: bool = false
var portal_path: String = "res://scenes/first_level_portal.tscn"
var portal_inst: Object = load(portal_path)

func _ready() -> void:
	$item_thrower_menu.hide()
	SignalBus.on_item_removed.connect(create_portal)

func create_portal() -> void:
	print("pedido portal criado")
	$CPUParticles3D.emitting = true
	if !Global.completed_levels["first_level"]:
		portal_path = "res://scenes/first_level_portal.tscn"
	elif !Global.completed_levels["second_level"]:
		print("portal segunda fase criado")
		portal_path = "res://scenes/second_level_portal.tscn"
	var portal: Object = portal_inst.instantiate()
	portal.position = Vector3(position.x,1.92,position.z-5.4)
	get_parent().add_child(portal)
	$Area3D/CollisionShape3D.set_deferred("disabled", true)
	await get_tree().create_timer(1).timeout
	$CPUParticles3D.emitting = false
	await get_tree().create_timer(.2).timeout
	hide()
	await get_tree().create_timer(.2).timeout
	queue_free()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and player_near:
		#$item_thrower_menu.show()
		if $item_thrower_menu:
			Global.player_can_move = false
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			$item_thrower_menu.show()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "player":
		player_near = true
		$npc_interact_sign.show()
		$npc_interact_sign.player = body

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name == "player":
		player_near = false
		$npc_interact_sign.hide()
		$npc_interact_sign.player = null
