extends Node3D

@export var state: String
@export var anim_player: AnimationPlayer

func _ready() -> void:
	set_state("idle")

func set_state(incoming_state: String) -> void:
	if incoming_state == "idle":
		anim_player.play("idle")
	elif incoming_state == "pre-attack":
		anim_player.play("pre-attack")
	elif incoming_state == "attack":
		anim_player.play("attack")
