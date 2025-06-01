extends Node2D

# NOTA PARA MIM MESMA: fazer com que o array com que os frames sejam construidos na hora
# ou montar um array que tenha cada frame integrado nele

var cur_frame = 0 ## @experimental: incompleto [br] um indicador para o frame atual
var frames := ["0", "1", "2", "3", "4"] ## array com cada frame representado por strings
@onready var frames_node: Node2D = $CanvasLayer/start_cutscene/frames

func _ready() -> void:
	$CanvasLayer.hide()
	SignalBus.on_ignite_cutscene.connect(cutscene)
	#if Global.cutscenes.start == false:
		#show()
		#get_tree().paused = true
		#cutscene()

func cutscene(scene: String):
	if scene == "start":
		$CanvasLayer.show()
		get_tree().paused = true
		for i in frames:
			if cur_frame == frames.size() - 1:
				print("stopped cutscene")
				return
			cur_frame = int(i)
			if cur_frame == frames.size() - 1:
				$CanvasLayer.hide()
				print("done")
				return
			
			# esconde todos os frames...
			for j in $CanvasLayer/start_cutscene/frames.get_child_count():
				$CanvasLayer/start_cutscene/frames.get_child(j).hide()
			
			# ...e aqui faz aparecer o único que precisa pra cutscene
			$CanvasLayer/start_cutscene/frames.get_node(i).show()
			print("node name: ",$CanvasLayer/start_cutscene/frames.get_node(i).name, "; is visible: ", $CanvasLayer/start_cutscene/frames.get_child(cur_frame).visible)
			
			# cada frame aparece a cada 2 segundos com esse timer
			await get_tree().create_timer(2).timeout
		
		# código quando acaba a cutscene
		$CanvasLayer.hide()
		get_tree().paused = false
	elif scene == "final":
		pass
		#print("ei")

func _physics_process(delta: float) -> void:
	pass


# um jeito muito estúpido de fazer a cutscene acabar (vou arrumar isso depois, por enquanto é só teste)
func _on_skip_cutscene_pressed() -> void:
	cur_frame = frames.size() - 1
