extends Node2D

@export var prefab_1: PackedScene
@export var prefab_2: PackedScene

var weapons_manager: Node2D
var player

var ammo: float = 6
var primary_cooldown: float
var secondary_cooldown: float

var game_object: Node2D

var direction: Vector2
var mouse_position: Vector2

var reloading: bool = false
var base_reload_time: float = 1.5
var reload_time: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()
	
	base_reload_time = 1.5 - 0.25 * ammo
	
	primary_cooldown -= delta
	secondary_cooldown -= delta
	reload_time -= delta
	if reloading == true:
		if reload_time < 0:
			reloading = false
			ammo = 6
	
	queue_redraw()


func _manager_add(stored_weapon):
	if stored_weapon == 1:
		weapons_manager.stored_weapon_1 = self
	if stored_weapon == 2:
		weapons_manager.stored_weapon_2 = self


func _attack_primary(delta: float) -> void:
	if Input.is_action_just_pressed("primary_action"):
		if primary_cooldown < 0:
			if ammo > 0:
				if reloading == false:
					ammo -= 1
					primary_cooldown = 0.05
					var inst = prefab_1.instantiate()
					inst.position = player.position
					inst.look_at(mouse_position)
					inst.rotation += deg_to_rad(-90)
					inst.knockback_position = inst.position
					game_object.add_child(inst)
			else:
				if reloading == false:
					reloading = true
					reload_time = base_reload_time


func _attack_secondary(delta: float) -> void:
	if Input.is_action_just_pressed("secondary_action"):
		if secondary_cooldown < 0:
			if ammo >= 3:
				if reloading == false:
					ammo -= 3
					secondary_cooldown = 1
					var inst = prefab_2.instantiate()
					inst.position = player.position
					inst.look_at(mouse_position)
					inst.rotation += deg_to_rad(-90)
					inst.knockback_position = inst.position
					inst.game_object = game_object
					game_object.add_child(inst)
			else:
				if reloading == false:
					reloading = true
					reload_time = base_reload_time


func _reload():
	reloading = true
	reload_time = base_reload_time


func _draw() -> void:
	if weapons_manager.equiped_weapon == self:
		if player != null:
			draw_line((player.global_position + Vector2(-60, -70)), (player.global_position + Vector2(((ammo * 20) - 60), -70)), Color.GREEN, 16)
			draw_arc(player.global_position, 100, 0, deg_to_rad(360 - (primary_cooldown * 7200)), 30, Color.CYAN, 5, true)
			draw_arc(player.global_position, 120, 0, deg_to_rad(360 - (secondary_cooldown * 360)), 30, Color.LAWN_GREEN, 5, true)
			if reloading:
				draw_arc(player.global_position, 140, 0, deg_to_rad(reload_time * 240), 30, Color.CRIMSON, 5, true)
