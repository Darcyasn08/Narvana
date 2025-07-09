extends Node3D

@export var model_3d: Node3D

func _on_visible_on_screen_notifier_3d_screen_entered() -> void:
	model_3d.show()

func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	model_3d.hide()
