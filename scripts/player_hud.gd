extends CanvasLayer

@onready var health_container: Control = $health
var hearts_list: Array
@onready var hud_life_inst: Object = preload("res://scenes/UI/hud_life.tscn")

func _ready() -> void:
	SignalBus.on_blush_hit.connect(blushed)
	SignalBus.on_player_health_changed.connect(change_player_health_status)
	SignalBus.on_item_removed.connect(show_removed_item)
	for life in Global.player_health:
		var hud_life: Object = hud_life_inst.instantiate()
		health_container.add_child(hud_life)
	$blush.hide()

func _physics_process(delta: float) -> void:
	$fps_label.text = str(snapped(Engine.get_frames_per_second(), 0.01))
	#print($fps_label.text)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("e"):
		pass
		#change_player_health_status(0)

func change_player_health_status(health: int) -> void:
	for child in health_container.get_children():
		child.queue_free()
	for life in Global.player_health:
		var hud_life: Object = hud_life_inst.instantiate()
		health_container.add_child(hud_life)
	#for i in range(hearts_list.size()):
		#hearts_list[i].visible = i < health #deixar visível apenas a qtd certa
	
	#if health == 1:
		#$health/TextureRect.modulate = Color(1,.2,.3)
	#elif health > 1:
		#$health/TextureRect.modulate = Color("#ffffff")
	#elif health < 1:
		#hearts_list[0].visible = false

func show_removed_item(item: String) -> void:
	$removed_item_label.text = str("O item [",item,"] foi removido!")
	await get_tree().create_timer(3).timeout
	$removed_item_label.text = ""

func blushed() -> void:
	$blush.show()
	await(get_tree().create_timer(4).timeout)
	$blush.hide()
