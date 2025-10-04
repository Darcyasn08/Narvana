extends CanvasLayer

## define o texto atual
var cur_text: int = 0

## carrega o nome do npc atual
var cur_npc: String = ""

## para checar se pode progredir no dialogo
var can_progress: bool = false

## define um valor aleatório, caso os dialogos de um npc possam ser aleatorios
var random_diag: int = 0

## variável para ver se o diálogo já começou
var has_started_diag: bool = false

## velocidade que o npc fala
var talk_speed: float

var pressed_option: int 

var has_option: bool = false

var npc_dialog: Dictionary
var npc_dialog_tree: Dictionary


@export var normal_talk_speed: float = .01
@export var fast_talk_speed: float = .008

@onready var dialog_options: Control = %dialog_options
@onready var diag_option_1: Button = $dialog_box/dialog_options/diag_option1
@onready var diag_option_2: Button = $dialog_box/dialog_options/diag_option2
@onready var dialog_text: RichTextLabel = $dialog_box/dialog_text
@onready var name_label: Label = $dialog_box/name_label


func _ready() -> void:
	SignalBus.on_dialog_activated.connect(start_dialogue)
	#SignalBus.on_dialog_area_leave.connect(end_dialog)
	hide()
	dialog_options.hide()


func _physics_process(_delta: float) -> void:
	pass

func check_done_dialog() -> void:
	if !Global.npc_manager[cur_npc]["is_first_time"]:
		npc_dialog = Global.dialogs[cur_npc]["dialog_tree"]["middle_done"][cur_text]
		npc_dialog_tree = Global.dialogs[cur_npc]["dialog_tree"]["middle_done"]
	else:
		npc_dialog = Global.dialogs[cur_npc]["dialog_tree"]["middle"][cur_text]
		npc_dialog_tree = Global.dialogs[cur_npc]["dialog_tree"]["middle"]

#função iniciada pelo sinal para iniciar o dialogo
func start_dialogue(npc: String) -> void:
	#garante que o [e] não seja clicado de novo no meio do dialogo
	if !has_started_diag:
		$dialog_box/dialog_text.text = ""
		Global.player_can_move = false
		talk_speed = normal_talk_speed
		has_started_diag = true
		cur_npc = npc
		cur_text = 0
		await check_done_dialog()
		check_options()
		name_label.text = Global.dialogs[cur_npc]["name"]
		show()
		for letter in npc_dialog["text"]:
			can_progress = false
			dialog_text.text += letter
			await get_tree().create_timer(talk_speed).timeout
			
			#se a caixa de dialogo for a mesma do dicionario, parar
			if dialog_text.text == npc_dialog["text"]:
				can_progress = true
				return
		can_progress = true
		talk_speed = normal_talk_speed #garante que a velocidade continue normal

#função pra terminar dialogo
func end_dialog() -> void:
	cur_text = 0
	cur_npc = ""
	dialog_text.text = ""
	dialog_options.hide()
	talk_speed = normal_talk_speed #reseta pra velociade normal, pra ter certeza
	hide()
	can_progress = false
	await get_tree().create_timer(.06).timeout
	Global.player_can_move = true
	has_started_diag = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

#esse checa se há opções de dialogo
func check_options() -> void:
	if npc_dialog["options"] == {}:
		pass #sem opções
	else: #se tiver opções, esse roda
		#print("there is an option")
		can_progress = false
		has_option = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		diag_option_1.text = npc_dialog["options"][0]["text"]
		diag_option_2.text = npc_dialog["options"][1]["text"]
		dialog_options.show()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("e") and has_option:
		can_progress = false
	if event.is_action_pressed("e") and can_progress and has_started_diag:
		progress_dialog() #se [e] for clicado, isso roda
	elif event.is_action_pressed("e") and !can_progress and has_started_diag and !has_option:
		dialog_text.text = npc_dialog_tree[cur_text]["text"]
		can_progress = true

#função para progressar dialogo
func progress_dialog() -> void:
	dialog_text.text = "" #reseta caixa pra garantir
	cur_text += 1
	if cur_text >= npc_dialog_tree.size():
		await get_tree().create_timer(.06).timeout #tempo pro dialogo não começar automaticamente
		if Global.npc_manager[cur_npc]["is_first_time"]:
			Global.npc_manager[cur_npc]["is_first_time"] = false
		end_dialog()
	else:
		#print("next")
		#print("tamanho: ",npc_dialog_tree.size())
		npc_dialog = npc_dialog_tree[cur_text]
		can_progress = false
		check_options()
		for letter in npc_dialog["text"]:
			if can_progress:
				return
			await get_tree().create_timer(talk_speed).timeout
			if can_progress: #pra checar frequentemente
				return
			dialog_text.text += letter
		can_progress = true
		talk_speed = normal_talk_speed
		dialog_text.text = npc_dialog["text"]

#checa qual opção foi pressionada
func check_pressed_option() -> void:
	dialog_text.text = ""
	if npc_dialog["options"][pressed_option]["ignite"] == "quest":
		print("And the quest is: ",Global.dialogs[cur_npc]["dialog_tree"]["quest"]["text"])
		dialog_text.text = Global.dialogs[cur_npc]["dialog_tree"]["quest"]["text"]
	
	elif npc_dialog["options"][pressed_option]["ignite"] == "exit":
		#print("exit please ma'am")
		dialog_text.text = Global.dialogs[cur_npc]["dialog_tree"]["exit"]["text"]
	
	elif npc_dialog["options"][pressed_option]["ignite"] == "continue":
		#print("continue with normal dialog")
		progress_dialog()
	
	elif npc_dialog["options"][pressed_option]["ignite"] == "function":
		print("alguma função tem que ser acionada aqui")
		dialog_text.text = Global.dialogs[cur_npc]["dialog_tree"]["function"]["text"]
		SignalBus.on_start_dialog_function.emit(cur_npc, Global.dialogs[cur_npc]["dialog_tree"]["function"]["id"])
	
	has_option = false


func _on_diag_option_1_pressed() -> void:
	dialog_options.hide()
	pressed_option = 0
	check_pressed_option()
	can_progress = true

func _on_diag_option_2_pressed() -> void:
	dialog_options.hide()
	pressed_option = 1
	check_pressed_option()
	can_progress = true
