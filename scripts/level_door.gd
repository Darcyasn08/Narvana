extends StaticBody3D

@export var room1: int
@export var room2: int
@onready var door_collision: CollisionShape3D = $CollisionShape3D

func _ready() -> void:
	SignalBus.on_start_room.connect(close)
	SignalBus.on_room_completed.connect(open)

func open(current_room):
	if current_room == room1 or current_room == room2:
		#print("door is open")
		door_collision.set_deferred("disabled", true)
		$AnimationPlayer.play("door_open")
		#hide()

func close(current_room):
	if current_room == room1 or current_room == room2:
		#print("door is closed")
		door_collision.set_deferred("disabled", false)
		$AnimationPlayer.play("door_close")
		#show()
