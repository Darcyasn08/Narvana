extends Button

@export var id: int
@export var text_name: String

func _ready() -> void:
	print(size)
	custom_minimum_size.y = 50
	text = text_name
	set_meta("id", id)
	self.pressed.connect(on_button_pressed)

func on_button_pressed() -> void:
	SignalBus.on_item_selected.emit(get_meta("id", id))
