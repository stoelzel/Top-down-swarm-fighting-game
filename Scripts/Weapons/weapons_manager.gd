extends Node2D

@export var sword_prefab: PackedScene
@export var shield_prefab: PackedScene
@export var gun_prefab: PackedScene
@export var fire_prefab: PackedScene

@onready var player: CharacterBody2D = %Player


var flame_thrower_ammo: float = 5.0


var equiped_weapon: Node2D

var stored_weapon_equiped: int

var stored_weapon_1: Node2D
var stored_weapon_2: Node2D

var mouse_position
var direction


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Singleton.weapon_1 == 1:
		_create_weapon_generator(sword_prefab, 1)
	elif Singleton.weapon_1 == 2:
		_create_weapon_generator(shield_prefab, 1)
	elif Singleton.weapon_1 == 3:
		_create_weapon_generator(gun_prefab, 1)
	elif Singleton.weapon_1 == 4:
		_create_weapon_generator(fire_prefab, 1)

	if Singleton.weapon_2 == 1:
		_create_weapon_generator(sword_prefab, 2)
	elif Singleton.weapon_2 == 2:
		_create_weapon_generator(shield_prefab, 2)
	elif Singleton.weapon_2 == 3:
		_create_weapon_generator(gun_prefab, 2)
	elif Singleton.weapon_2 == 4:
		_create_weapon_generator(fire_prefab, 2)

	stored_weapon_equiped = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	mouse_position = get_global_mouse_position()
	direction = (mouse_position - player.position).normalized()
	if Input.is_action_pressed("1"):
		stored_weapon_equiped = 1
	elif Input.is_action_pressed("2"):
		stored_weapon_equiped = 2
	
	if stored_weapon_equiped == 1:
		equiped_weapon = stored_weapon_1
		if equiped_weapon.has_method("_attack_primary") == true:
			equiped_weapon.player = player
			equiped_weapon.game_object = owner
			equiped_weapon.direction = (mouse_position - player.position).normalized()
	elif stored_weapon_equiped == 2:
		equiped_weapon = stored_weapon_2
		if equiped_weapon.has_method("_attack_primary") == true:
			equiped_weapon.player = player
			equiped_weapon.game_object = owner
			equiped_weapon.direction = (mouse_position - player.position).normalized()
	
	if Input.is_action_pressed("primary_action"):
		if equiped_weapon != null:
			if "mouse_position" in equiped_weapon:
				equiped_weapon.mouse_position = mouse_position
			if equiped_weapon.has_method("_attack_primary") == true:
				equiped_weapon.player = player
				equiped_weapon.game_object = owner
				equiped_weapon.direction = (mouse_position - player.position).normalized()
				equiped_weapon._attack_primary(delta)
	
	if Input.is_action_pressed("secondary_action"):
		if equiped_weapon != null:
			if "mouse_position" in equiped_weapon:
				equiped_weapon.mouse_position = mouse_position
			if equiped_weapon.has_method("_attack_secondary") == true:
				equiped_weapon.player = player
				equiped_weapon.game_object = owner
				equiped_weapon.direction = (mouse_position - player.position).normalized()
				equiped_weapon._attack_secondary(delta)
	
	if Input.is_action_pressed("reload"):
		if equiped_weapon != null:
			if equiped_weapon.has_method("_reload") == true:
				equiped_weapon._reload()
	
	
	queue_redraw()


func _create_weapon_generator(prefab, stored_weapon):
	var inst = prefab.instantiate()
	inst.weapons_manager = self
	inst._manager_add(stored_weapon)
	add_child(inst)


#func _draw() -> void:
#	if equiped_weapon != null:
#		if equiped_weapon.primary_cooldown < 0:
#			draw_circle(player.global_position, 70, Color.AQUA, false, 5.0, false)
