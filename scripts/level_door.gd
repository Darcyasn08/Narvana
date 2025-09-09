extends StaticBody3D

@export var room1: int
@export var room2: int
@export var is_from_level: bool = true
@onready var door_collision: CollisionShape3D = $CollisionShape3D

var player_near: bool = false

func _ready() -> void:
	if is_from_level:
		SignalBus.on_start_room.connect(close)
		SignalBus.on_room_completed.connect(open)
		if $bg_effect:
			$bg_effect.hide()
	else:
		$Area3D.body_entered.connect(on_body_entered)
		$Area3D.body_exited.connect(on_body_exited)
		if $bg_effect:
			$bg_effect.show()

func open(current_room):
	if current_room == room1 or current_room == room2:
		#print("door is open")
		door_collision.set_deferred("disabled", true)
		$AnimationPlayer.play("door_open")
		if $MeshInstance3D:
			$MeshInstance3D.hide()
			$CollisionShape3D.set_deferred("disabled", true)

func close(current_room):
	if current_room == room1 or current_room == room2:
		#print("door is closed")
		door_collision.set_deferred("disabled", false)
		$AnimationPlayer.play("door_close")
		if $MeshInstance3D:
			$MeshInstance3D.show()
			$CollisionShape3D.set_deferred("disabled", false)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and player_near:
		print("entrar de novo na fase")

func on_body_entered(body: Node3D) -> void:
	if body.name == "player":
		player_near = true
		print("is near")
		$AnimationPlayer.play("door_open")

func on_body_exited(body: Node3D) -> void:
	if body.name == "player":
		player_near = false
		$AnimationPlayer.play("door_close")
