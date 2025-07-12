extends CanvasLayer

@onready var health_container: Control = $health
var hearts_list: Array[TextureRect]

func _ready() -> void:
	SignalBus.on_player_health_changed.connect(change_player_health_status)
	for child in health_container.get_children():
		hearts_list.append(child)
	#print(hearts_list)

func _physics_process(delta: float) -> void:
	$fps_label.text = str(snapped(Engine.get_frames_per_second(), 0.01))

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("e"):
		pass
		#change_player_health_status(0)

func change_player_health_status(health: int) -> void:
	for i in range(hearts_list.size()):
		hearts_list[i].visible = i < health #deixar visível apenas a qtd certa
		#print(i<health)
	
	if health == 1:
		$health/TextureRect.modulate = Color(1,.2,.3)
	elif health > 1:
		$health/TextureRect.modulate = Color("#ffffff")
	elif health < 1:
		hearts_list[0].visible = false
