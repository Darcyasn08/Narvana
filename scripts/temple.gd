extends Node3D

@onready var first_level_portal_inst: Object = preload("res://scenes/first_level_portal.tscn")

func _ready() -> void:
	print("first level: ",Global.completed_levels["first_level"])
	if Global.completed_levels["first_level"]:
		var first_level_portal: Object = first_level_portal_inst.instantiate()
		first_level_portal.position = Vector3(.3,1,-29.7)
		add_child(first_level_portal)
