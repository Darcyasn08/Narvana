extends CharacterBody3D

var speed : float
var follow : bool
var pos : Vector3
var rot : Vector3
var model : float #futuramente colocar pra essa variavel determinar o modelo do tiro
var damage : int

@onready var player = $"../player"

func _ready() -> void:
	global_position = pos
	rotation = rot
	
func _physics_process(delta: float) -> void:
	var forward := global_basis.z #determina oq é a frente 
	var move_direction := forward 
	move_direction.y = 0.0 #reseta o de y, pq ele não muda na hora de mover
	move_direction = move_direction.normalized() #nao sei oq isso faz
	velocity = velocity.move_toward(move_direction * -speed, 20000) #move pra frente
	
	if follow == true:
		look_at(player.global_position)

	move_and_slide()


func _on_hurtbox_area_entered(area: Area3D) -> void:
	if area.name == "player_hitbox":
		get_tree().call_group("player","hurt",damage)
		queue_free()
