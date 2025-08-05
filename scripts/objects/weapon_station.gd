extends Node3D

var player_near: bool = false
var weapon_number: int = 0
var weapons_to_show: Array = [true, true, false, false]

func _ready() -> void:
	for weapon in Global.weapons:
		weapon_number += 1

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact") and player_near:
		#if Global.current_weapon == 1:
			#print("bat now")
			#SignalBus.on_change_player_weapon.emit(2)
		#elif Global.current_weapon == 2:
			#print("tonfa now")
			#SignalBus.on_change_player_weapon.emit(1)
		#$Timer.start()
		#if Global.n == 0:
		if Global.current_weapon == Global.weapons.BAT:
			print("bat now")
			#Global.n = 1
			Global.current_weapon = Global.weapons.TONFA
			SignalBus.on_change_player_weapon.emit(2)
			print(Global.current_weapon)
		elif Global.current_weapon == Global.weapons.TONFA:
			print("tonfa now")
			#Global.n = 0
			Global.current_weapon = Global.weapons.BAT
			SignalBus.on_change_player_weapon.emit(1)
			print(Global.current_weapon)
		change_shown_weapon()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "player":
		player_near = true

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name == "player":
		player_near = false

func change_shown_weapon() -> void:
	if Global.current_weapon == Global.weapons.BAT:
		$bat.hide()
		$tonfa.show()
		$mangual.show()
	elif Global.current_weapon == Global.weapons.TONFA:
		$bat.show()
		$tonfa.hide()
		$mangual.show()
	
	#for unlocked_weapon in Global.unlocked_weapons:
		#if unlocked_weapon:
			#weapons_to_show[unlocked_weapon] = true
		#else:
			#weapons_to_show[unlocked_weapon] = false
	#
	#if weapons_to_show[1] == true:
		#$bat.show()
	#else:
		#$bat.hide()
	
