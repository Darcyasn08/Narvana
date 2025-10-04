extends Camera3D

@onready var initial_camera_rotation: Vector3 = rotation_degrees
@onready var trauma_reduction_rate: float = 1.0

var max_x: float = 8.0
var max_y: float = 8.0
var max_z: float = 4.0
var time: float = 0.0
var trauma: float = 0.0

@export var noise: NoiseTexture2D
var noise_speed: float = 50.0

var is_shaking: bool = false

func _physics_process(delta: float) -> void:
	time += delta
	trauma = max(trauma - delta * trauma_reduction_rate, 0.0)
	#if is_shaking:
	rotation_degrees.x = initial_camera_rotation.x + max_x * get_shake_intensity() * get_noise_from_seed(0)
	rotation_degrees.y = initial_camera_rotation.y + max_y * get_shake_intensity() * get_noise_from_seed(1)
	rotation_degrees.z = initial_camera_rotation.z + max_z * get_shake_intensity() * get_noise_from_seed(2)
	#rotation_degrees = rotation_degrees + Vector3(randf_range(-max_x,max_x),randf_range(-max_y,max_y),randf_range(-max_z,max_z))

func add_trauma(trauma_amount: float) -> void:
	trauma = clamp(trauma + trauma_amount,0.0,1.0)

func get_shake_intensity() -> float:
	return trauma * trauma
	print(trauma)

func shake_camera() -> void:
	is_shaking = true
	print("camera shake")
	await get_tree().create_timer(.4).timeout
	is_shaking = false

func get_noise_from_seed(seed: int) -> float:
	noise.noise.seed = seed
	return noise.noise.get_noise_1d(time * noise_speed)
