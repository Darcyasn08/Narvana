extends CanvasLayer

var n = 0
var has_started_diag: bool = false
var cur_text := 0
var cur_npc := ""
var can_progress: bool = false
var random_diag: int = 0

func _ready() -> void:
	print("im here")
	SignalBus.on_dialogue_activated.connect(start_dialog)
	SignalBus.on_dialog_area_leave.connect(end_dialog)
	hide()
	$diag_option1.hide()
	$diag_option2.hide()

func _physics_process(delta: float) -> void:
	progress_dialogue()

func start_dialog(npc):
	#print(random_diag)
	if !has_started_diag:
		print("start diag")
		has_started_diag = true
		cur_npc = npc
		random_diag = randi_range(0,Global.dialogues[npc].size() - 1)
		cur_text = 0
		#print(cur_npc)
		can_progress = true
		show()
		$next_label.show()
		#print(Global.dialogues[npc][0])
		$name_label.text = cur_npc
		for letter in Global.dialogues[cur_npc][random_diag][cur_text]:
			can_progress = false
			await get_tree().create_timer(.04).timeout
			print(letter)
			$dialogue_text.text += letter
		can_progress = true
		#$dialogue_text.text = Global.dialogues[npc][random_diag][0]

func end_dialog():
	cur_text = 0
	cur_npc = ""
	print("limit")
	has_started_diag = false
	hide()
	can_progress = false
	SignalBus.on_ignite_cutscene.emit("final")
	return

func progress_dialogue():
	if Input.is_action_just_pressed("left_click") and can_progress:
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
					await get_tree().create_timer(.04).timeout
					#print(letter)
					$dialogue_text.text += letter
				can_progress = true
				#$dialogue_text.text = Global.dialogues[cur_npc][random_diag][cur_text]
			#print($dialogue_text.text)

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
