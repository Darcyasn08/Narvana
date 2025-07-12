extends Control
class_name InventoryItem

@export var text: String
@export var icon_path: String
@export var desc: String
var mouse_hover_panel: Panel = Panel.new()
var hover_panel_stylebox: StyleBoxFlat = StyleBoxFlat.new()
var item_icon: Sprite2D = Sprite2D.new()

func _ready() -> void:
	#definir style do mouse_hover
	hover_panel_stylebox.bg_color = Color("#9f7e60")
	hover_panel_stylebox.set_corner_radius_all(5)
	
	#definir style do painel normal
	var item_stylebox: StyleBoxFlat = StyleBoxFlat.new()
	item_stylebox.bg_color = Color("#b1973c", 0)
	
	var label: Label = Label.new()
	var panel: Panel = Panel.new()
	var item_name_label: Label = Label.new()
	var item_desc_label: Label = Label.new()
	
	panel.add_theme_stylebox_override("panel", item_stylebox)
	mouse_hover_panel.add_theme_stylebox_override("panel", hover_panel_stylebox)
	panel.size = Vector2(100,100)
	label.text = text
	item_name_label.text = text
	item_desc_label.text = desc
	item_icon.texture = load(icon_path)
	item_icon.scale = Vector2(.26,.26)
	item_icon.position = Vector2(47,45)
	
	#sinais
	panel.mouse_entered.connect(check_mouse_entered)
	panel.mouse_exited.connect(check_mouse_exited)
	panel.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	mouse_hover_panel.size = Vector2(250,140)
	
	add_child(panel)
	add_child(item_icon)
	
	get_parent().get_parent().add_child(mouse_hover_panel)
	item_name_label.position = Vector2(10,20)
	mouse_hover_panel.add_child(item_name_label)
	
	item_desc_label.position = item_name_label.position + Vector2(0,25)
	mouse_hover_panel.add_child(item_desc_label)
	print(item_desc_label)
	
	mouse_hover_panel.hide()


func _physics_process(_delta: float) -> void:
	pass

func check_mouse_entered() -> void:
	mouse_hover_panel.position = get_viewport().get_mouse_position() + Vector2(12,-150)
	item_icon.scale = Vector2(.32,.32)
	mouse_hover_panel.show()
	#print(mouse_hover_panel.position)

func check_mouse_exited() -> void:
	item_icon.scale = Vector2(.26,.26)
	mouse_hover_panel.hide()
