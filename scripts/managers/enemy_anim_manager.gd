extends Node3D

@export var state: String
@export var anim_player: AnimationPlayer

func _ready() -> void:
	set_state("idle")

func set_state(incoming_state: String) -> void:
	if incoming_state == "idle":
		anim_player.play("idle")
	else:
		anim_player.play(incoming_state)
