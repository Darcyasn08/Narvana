extends Node3D

var player_near: bool = false
var npc_name: String = "crab"

func _ready() -> void:
	SignalBus.on_start_dialog_function.connect(open_shop)
	$shop_screen.hide()

func open_shop(emmited_name: String) -> void:
	if emmited_name == npc_name:
		get_tree().paused = true
		$shop_screen.show()
