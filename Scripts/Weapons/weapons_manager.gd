extends Node2D

@export var sword_1_prefab: PackedScene
@export var shield_1_prefab: PackedScene
@export var gun_1_prefab: PackedScene
@export var fire_1_prefab: PackedScene

@onready var player: CharacterBody2D = %Player


#weapons
enum weapons {
	nothing,
	sword,
	shield,
	gun,
	flame_thrower,
	}

var gun_ammo: float = 6.0
var flame_thrower_ammo: float = 5.0


var equiped_weapon: weapons

var stored_weapon_equiped: int

var stored_weapon_1: weapons = weapons.shield
var stored_weapon_2: weapons = weapons.flame_thrower

var primary_cooldown: float

var mouse_position
var direction

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stored_weapon_equiped = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	primary_cooldown -= delta
	
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
	
	#passive effects
	match equiped_weapon:
		_:
			pass
	
	#active press effects for primary action
	if Input.is_action_just_pressed("primary_action"):
		if primary_cooldown < 0:
			match equiped_weapon:
				weapons.sword:
					_sword_swing()
				weapons.gun:
					_gun_fire()
				_:
					pass
		
		match equiped_weapon:
			_:
				pass
	
	#active held effects for primary action
	if Input.is_action_pressed("primary_action"):
		if primary_cooldown < 0:
			match equiped_weapon:
				weapons.flame_thrower:
					_fire_throw()
				_:
					pass
		
		match equiped_weapon:
			weapons.shield:
				_shield()
			_:
				pass

func _sword_swing():
	primary_cooldown = 0.3
	var inst = sword_1_prefab.instantiate()
	inst.position = player.position
	inst.position += 100 * direction
	inst.look_at(player.position)
	inst.rotation += deg_to_rad(-90)
	inst.knockback_position = inst.position - (50 * direction)
	owner.add_child(inst)

func _shield():
	var inst = shield_1_prefab.instantiate()
	inst.position = player.position
	inst.position += 100 * direction
	inst.look_at(player.position)
	inst.rotation += deg_to_rad(-90)
	inst.knockback_position = inst.position - (50 * direction)
	owner.add_child(inst)

func _gun_fire():
	if gun_ammo > 0:
		gun_ammo -= 1
		primary_cooldown = 0.05
		var inst = gun_1_prefab.instantiate()
		inst.position = player.position
		inst.look_at(mouse_position)
		inst.rotation += deg_to_rad(-90)
		inst.knockback_position = inst.position
		owner.add_child(inst)
	elif gun_ammo <= 0:
		primary_cooldown = 0.8
		gun_ammo = 6.0

func _fire_throw():
	primary_cooldown = 0.1
	var inst = fire_1_prefab.instantiate()
	inst.position = player.position
	inst.look_at(mouse_position)
	inst.rotation += deg_to_rad((-90 * randf_range(0.95, 1.05)))
	inst.knockback_position = inst.position
	owner.add_child(inst)

func _draw() -> void:
	if primary_cooldown < 0:
		draw_circle(player.global_position, 70, Color.AQUA, false, 5.0, false)
	match equiped_weapon:
		weapons.gun:
			if primary_cooldown < 0:
				draw_line((player.global_position + Vector2(-60, 70)), (player.global_position + Vector2(((gun_ammo * 20) - 60), 70)), Color.GREEN, 16)
		_:
			pass
	
	
	
