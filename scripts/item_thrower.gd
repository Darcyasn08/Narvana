extends Node3D

var player_near: bool = false
var portal_inst: Object = preload("res://scenes/first_level_portal.tscn")

func _ready() -> void:
	$item_thrower_menu.hide()
	SignalBus.on_item_removed.connect(create_portal)
	print("it is ready")

func create_portal(item: String) -> void:
	$CPUParticles3D.emitting = true
	var portal: Object = portal_inst.instantiate()
	portal.position = Vector3(position.x,1.92,position.z-5.4)
	print("portal is here!")
	get_parent().add_child(portal)
	$Area3D/CollisionShape3D.set_deferred("disabled", true)
	await get_tree().create_timer(1).timeout
	$CPUParticles3D.emitting = false
	await get_tree().create_timer(.2).timeout
	#queue_free()
	hide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and player_near:
		#$item_thrower_menu.show()
		print(get_children())
		if $item_thrower_menu:
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
