extends CharacterBody3D

var speed : float
var follow : bool
var pos : Vector3
var rot : Vector3
var size : float
var model : float #futuramente colocar pra essa variavel determinar o modelo do tiro
var damage : int
var blush : bool = false
var stunner : bool = false
var stun_time : float 

var player_path: String = "player"
@onready var player: CharacterBody3D = get_node(player_path)

func _ready() -> void:
	global_position = pos
	rotation = rot
	if size != 0.0:
		scale = Vector3(size,size,size)
	
func _physics_process(_delta: float) -> void:
	var forward: Vector3 = global_basis.z #determina oq é a frente 
	var move_direction: Vector3 = forward 
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
		if blush == false and stunner == false:
			get_tree().call_group("player","hurt",damage)
			queue_free()
	if area.name != "player_hitbox" and !area.is_in_group("enemies") and !area.is_in_group("spawners") and !area.is_in_group("enemy_other"):
		queue_free()

func _on_hurtbox_body_entered(body: Node3D) -> void:
	if !body.is_in_group("enemies") and !body.is_in_group("spawners"):
		queue_free()
