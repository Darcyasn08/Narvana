extends Node3D

var npc_name: String = "master"
var portal_inst = preload("res://scenes/first_level_portal.tscn")

func _ready() -> void:
	SignalBus.on_start_dialog_function.connect(open_portal)

func open_portal(emmited_name):
	if emmited_name == npc_name:
		var portal = portal_inst.instantiate()
		print("open the portal, please!")
		portal.position = $portal_pos.position
		add_child(portal)
