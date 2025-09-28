extends CanvasLayer

@onready var health_container: Control = $health
var hearts_list: Array
@onready var hud_life_inst: Object = preload("res://scenes/UI/hud_life.tscn")
var counter: int = 0

func _ready() -> void:
	SignalBus.on_blush_hit.connect(blushed)
	SignalBus.on_player_health_changed.connect(change_player_health_status)
	SignalBus.on_use_magic.connect(start_magic_timer)
	SignalBus.on_item_removed.connect(show_removed_item)
	SignalBus.on_thermal_water_used.connect(show_max_health_label)
	
	for life in Global.player_health:
		var hud_life: Object = hud_life_inst.instantiate()
		health_container.add_child(hud_life)
	$blush.hide()

func _physics_process(delta: float) -> void:
	$fps_label.text = str(snapped(Engine.get_frames_per_second(), 0.01))
	#Time.get_ticks_msec()
	counter += delta*1000
	if counter%5==0:
		$magics/magic_time_label.text = str(snapped($magics/magics_timer.time_left,1))
		counter = 0

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("e"):
		pass
		#change_player_health_status(0)

func show_max_health_label() -> void:
	$thermal_water_label.show()
	await get_tree().create_timer(3).timeout
	$thermal_water_label.hide()

func change_player_health_status(health: int) -> void:
	for child in health_container.get_children():
		child.queue_free()
	for life in Global.player_health:
		var hud_life: Object = hud_life_inst.instantiate()
		health_container.add_child(hud_life)

func show_removed_item(item: String) -> void:
	$removed_item_label.text = str("Você desapegou do item: ",Global.inventory["items"][item]["name"])
	await get_tree().create_timer(4).timeout
	$removed_item_label.text = ""

func blushed() -> void:
	$blush.show()
	await(get_tree().create_timer(4).timeout)
	$blush.hide()

func start_magic_timer() -> void:
	$magics/magics_timer.start()
	$magics/dust_magic.modulate = Color("#5071a1")
	$magics/magic_time_label.show()

func _on_magics_timer_timeout() -> void:
	$magics/magic_time_label.hide()
	$magics/dust_magic.modulate = Color("ffffffff")
