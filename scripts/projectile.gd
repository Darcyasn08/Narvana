extends CharacterBody3D

var speed : float
var follow : bool
var pos : Vector3
var rot : Vector3
var model : float #futuramente colocar pra essa variavel determinar o modelo do tiro
var damage : int
var blush : bool = false

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
		if blush:
			SignalBus.on_blush_hit.emit()
			queue_free()
		if blush == false:
			get_tree().call_group("player","hurt",damage)
			queue_free()
	if area.name != "player_hitbox" and !area.is_in_group("enemies") and !area.is_in_group("spawners"):
		queue_free()


func _on_hurtbox_body_entered(body: Node3D) -> void:
	if !body.is_in_group("enemies") and !body.is_in_group("spawners"):
		queue_free()
