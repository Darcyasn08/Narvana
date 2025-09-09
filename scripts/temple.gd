extends Node3D

@onready var first_level_door_inst: Object = preload("res://scenes/first_level_door.tscn")

func _ready() -> void:
	print("first level: ",Global.completed_levels["first_level"])
	if Global.completed_levels["first_level"]:
		var first_level_door: Object = first_level_door_inst.instantiate()
		first_level_door.position = Vector3(.3,1.92,-29.7)
		first_level_door.is_from_level = false
		add_child(first_level_door)
