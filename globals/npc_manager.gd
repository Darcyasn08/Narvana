extends Node3D

@export_category("Npc details")
@export var current_npc: String = ""

#@export var npc_name = ["crab", "jellyfish", "mint"]
enum npc_name {CRAB, JELLYFISH}

func _ready() -> void:
	pass
