extends CanvasLayer

## define o texto atual
var cur_text := 0

## carrega o nome do npc atual
var cur_npc := ""

## para checar se pode progredir no dialogo
var can_progress: bool = false

## define um valor aleatório, caso os dialogos de um npc possam ser aleatorios
var random_diag: int = 0

## variável para ver se o diálogo já começou
var has_started_diag: bool = false

## velocidade que o npc fala
var talk_speed: float

@export var normal_talk_speed: float = .05
@export var fast_talk_speed: float = 0.003


"""
asfdajoefij
asfjid
"""


func _ready() -> void:
	SignalBus.on_dialogue_activated.connect(start_dialogue)
	SignalBus.on_dialog_area_leave.connect(end_dialog)
	hide()
	$diag_option1.hide()
	$diag_option2.hide()


func _physics_process(_delta: float) -> void:
	progress_dialogue()


#função iniciada pelo sinal para iniciar o dialogo
func start_dialogue(npc):
	#caso "e" tenha sido clicado de novo, e o dialogo já tiver começado, não começar
	if !has_started_diag:
		#print("start diag")
		talk_speed = normal_talk_speed
		has_started_diag = true
		cur_npc = npc
		random_diag = randi_range(0,Global.dialogues[npc].size() - 1)
		cur_text = 0
		can_progress = true
		show()
		$next_label.show()
		$name_label.text = cur_npc
		for letter in Global.dialogues[cur_npc][random_diag][cur_text]:
			can_progress = false
			await get_tree().create_timer(talk_speed).timeout
			#print(letter)
			$dialogue_text.text += letter
		can_progress = true
		talk_speed = normal_talk_speed #garante que a velocidade continue normal


func end_dialog():
	cur_text = 0
	cur_npc = ""
	$dialogue_text.text = ""
	talk_speed = normal_talk_speed #reseta pra velociade normal, pra ter certeza
	print("limit")
	has_started_diag = false
	hide()
	can_progress = false
	SignalBus.on_ignite_cutscene.emit("final")
	return


func progress_dialogue():
	if Input.is_action_just_pressed("e") and can_progress and has_started_diag:
		$dialogue_text.text = "" #reseta o dialogo
		cur_text += 1
		if cur_text == Global.dialogues[cur_npc][random_diag].size():
			end_dialog()
		else:
			if cur_text == Global.dialogues[cur_npc][random_diag].size() - 1:
				$next_label.hide()
			if Global.dialogues[cur_npc][random_diag][cur_text].find(";") != -1:
				#print("in: ",cur_text," there is a ;")
				print(Global.dialogues[cur_npc][random_diag][cur_text].get_slice(";", 0))
				#print(cur_text)
				$diag_option1.show()
				$diag_option2.show()
				#$name_label.hide()
				$diag_option1.text = Global.dialogues[cur_npc][random_diag][cur_text].get_slice(";", 0)
				$diag_option2.text = Global.dialogues[cur_npc][random_diag][cur_text].get_slice(";", 1)
				can_progress = false
				$dialogue_text.text = ""
				
			else:
				$name_label.show()
				$diag_option1.hide()
				$diag_option2.hide()
				#print(cur_text)
				for letter in Global.dialogues[cur_npc][random_diag][cur_text]:
					can_progress = false
					await get_tree().create_timer(talk_speed).timeout
					#print(letter)
					$dialogue_text.text += letter
				can_progress = true
				talk_speed = normal_talk_speed
				#$dialogue_text.text = Global.dialogues[cur_npc][random_diag][cur_text]
			#print($dialogue_text.text)
	elif Input.is_action_just_pressed("e") and !can_progress and has_started_diag:
		print("too fast")
		talk_speed = fast_talk_speed


func _on_diag_option_1_pressed() -> void:
	$diag_option1.hide()
	$diag_option2.hide()
	$dialogue_text.text = Global.dialogues[cur_npc][random_diag][cur_text].get_slice(";", 2)
	print("first button pressed")
	can_progress = true

func _on_diag_option_2_pressed() -> void:
	$diag_option1.hide()
	$diag_option2.hide()
	$dialogue_text.text = Global.dialogues[cur_npc][random_diag][cur_text].get_slice(";", 3)
	print("second button pressed")
	can_progress = true
