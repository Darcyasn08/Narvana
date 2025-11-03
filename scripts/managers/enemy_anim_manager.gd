extends Node3D

@export var state: String
@export var anim_player: AnimationPlayer

func _ready() -> void:
	set_state("idle")

func _physics_process(delta: float) -> void:
	if name == "seahorse_model":
		print($seahorse.rotation)
		print("pos: ",$seahorse.position)
		#print("seahorse model model: ",$seahorse.visible)
		print("just model: ", visible)

func set_state(incoming_state: String) -> void:
	if incoming_state == "idle":
		anim_player.play("idle")
	else:
		anim_player.play(incoming_state)
	#fazer um for pegando cada braço do polvo, ou alterar animation player
