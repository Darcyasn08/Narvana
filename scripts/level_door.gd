extends MeshInstance3D

@export var room1: int
@export var room2: int
@onready var door_collision: CollisionShape3D = $StaticBody3D/CollisionShape3D


func _ready() -> void:
	SignalBus.on_start_room.connect(close)
	SignalBus.on_room_completed.connect(open)

func open(current_room):
	if current_room == room1 or current_room == room2:
		print("door is open")
		door_collision.disabled = true
		hide()

func close(current_room):
	if current_room == room1 or current_room == room2:
		print("door is closed")
		door_collision.disabled = false
		show()
