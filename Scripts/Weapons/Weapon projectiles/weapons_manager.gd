extends Node2D

@export var sword_prefab: PackedScene
@export var shield_prefab: PackedScene
@export var gun_prefab: PackedScene
@export var fire_prefab: PackedScene

@onready var player: CharacterBody2D = %Player


#weapons
#enum weapons {
	#nothing,
	#sword,
	#shield,
	#gun,
	#flame_thrower,
	#}

var flame_thrower_ammo: float = 5.0


var equiped_weapon: Node2D

var stored_weapon_equiped: int

var stored_weapon_1: Node2D
var stored_weapon_2: Node2D

var mouse_position
var direction

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#stored_weapon_1 = Singleton.weapon_1
	#stored_weapon_2 = Singleton.weapon_2
	stored_weapon_equiped = 1
	_create_weapon_generator(fire_prefab, 1)
	_create_weapon_generator(gun_prefab, 2)


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
	elif stored_weapon_equiped == 2:
		equiped_weapon = stored_weapon_2
	
	queue_redraw()
	
	##passive effects
	#match equiped_weapon:
		#_:
			#pass
	
	if Input.is_action_pressed("primary_action"):
		if equiped_weapon != null:
			if "mouse_position" in equiped_weapon:
				equiped_weapon.mouse_position = mouse_position
			if equiped_weapon.has_method("_attack_primary") == true:
				equiped_weapon.player = player
				equiped_weapon.game_object = owner
				equiped_weapon.direction = (mouse_position - player.position).normalized()
				equiped_weapon._attack_primary(delta)
	
	if Input.is_action_pressed("reload"):
		if equiped_weapon != null:
			if equiped_weapon.has_method("_reload") == true:
				equiped_weapon._reload()
	
	##active press effects for primary action
	#if Input.is_action_just_pressed("primary_action"):
		#if primary_cooldown < 0:
			#match equiped_weapon:
				#weapons.sword:
					#_sword_swing()
				#weapons.gun:
					#_gun_fire()
				#_:
					#pass
		#
		#match equiped_weapon:
			#_:
				#pass
	#
	##active held effects for primary action
	#if Input.is_action_pressed("primary_action"):
		#if primary_cooldown < 0:
			#match equiped_weapon:
				#weapons.flame_thrower:
					#_fire_throw()
				#_:
					#pass
		#
		#match equiped_weapon:
			#weapons.shield:
				#_shield()
			#_:
				#pass

func _create_weapon_generator(prefab, stored_weapon):
	var inst = prefab.instantiate()
	inst.weapons_manager = self
	inst._manager_add(stored_weapon)
	add_child(inst)

#func _sword_swing():
	#primary_cooldown = 0.3
	#var inst = sword_1_prefab.instantiate()
	#inst.position = player.position
	#inst.position += 100 * direction
	#inst.look_at(player.position)
	#inst.rotation += deg_to_rad(-90)
	#inst.knockback_position = inst.position - (50 * direction)
	#owner.add_child(inst)
#
#func _shield():
	#var inst = shield_1_prefab.instantiate()
	#inst.position = player.position
	#inst.position += 100 * direction
	#inst.look_at(player.position)
	#inst.rotation += deg_to_rad(-90)
	#inst.knockback_position = inst.position - (50 * direction)
	#owner.add_child(inst)
#
#func _gun_fire():
	#if gun_ammo > 0:
		#gun_ammo -= 1
		#primary_cooldown = 0.05
		#var inst = gun_1_prefab.instantiate()
		#inst.position = player.position
		#inst.look_at(mouse_position)
		#inst.rotation += deg_to_rad(-90)
		#inst.knockback_position = inst.position
		#owner.add_child(inst)
	#elif gun_ammo <= 0:
		#primary_cooldown = 0.8
		#gun_ammo = 6.0
#
#func _fire_throw():
	#primary_cooldown = 0.1
	#var inst = fire_1_prefab.instantiate()
	#inst.position = player.position
	#inst.look_at(mouse_position)
	#inst.rotation += deg_to_rad((-90 * randf_range(0.95, 1.05)))
	#inst.knockback_position = inst.position
	#owner.add_child(inst)

func _draw() -> void:
	if equiped_weapon != null:
		if equiped_weapon.primary_cooldown < 0:
			draw_circle(player.global_position, 70, Color.AQUA, false, 5.0, false)
