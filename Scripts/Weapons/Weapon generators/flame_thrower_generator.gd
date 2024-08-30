extends Node2D

@export var prefab_1: PackedScene

var weapons_manager: Node2D
var player

var ammo: float = 2
var primary_cooldown: float
var secondary_cooldown: float

var game_object: Node2D

var direction: Vector2
var mouse_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()
	
	primary_cooldown -= delta
	secondary_cooldown -= delta
	
	if !Input.is_action_pressed("primary_action") or weapons_manager.equiped_weapon != self:
		ammo += delta / 2
	
	if ammo > 2:
		ammo = 2
	
	queue_redraw()


func _manager_add(stored_weapon):
	if stored_weapon == 1:
		weapons_manager.stored_weapon_1 = self
	if stored_weapon == 2:
		weapons_manager.stored_weapon_2 = self


func _attack_primary(delta: float) -> void:
	if primary_cooldown < 0:
		if ammo > 0:
			primary_cooldown = 0.1
			var inst = prefab_1.instantiate()
			inst.position = player.position
			inst.look_at(mouse_position)
			inst.rotation += deg_to_rad((-90 * randf_range(0.95, 1.05)))
			inst.knockback_position = inst.position
			game_object.add_child(inst)
			ammo -= 0.1
	#if ammo > 0:
		#ammo -= delta


func _attack_secondary(delta: float) -> void:
	if Input.is_action_just_pressed("secondary_action"):
		if secondary_cooldown < 0:
			while ammo > 0.08:
				secondary_cooldown = 0.75
				var inst = prefab_1.instantiate()
				inst.position = player.position
				inst.look_at(mouse_position)
				inst.rotation += deg_to_rad((-90 * randf_range(0.85, 1.15)))
				inst.knockback_position = inst.position
				game_object.add_child(inst)
				ammo -= 0.08


func _draw() -> void:
	if weapons_manager.equiped_weapon == self:
		if player != null:
			draw_line((player.global_position + Vector2(-60, -70)), (player.global_position + Vector2(((ammo * 60) - 60), -70)), Color.GREEN, 16)
			draw_arc(player.global_position, 100, 0, deg_to_rad(360 - (primary_cooldown * 3600)), 30, Color.CYAN, 5, true)
			draw_arc(player.global_position, 120, 0, deg_to_rad(360 - (secondary_cooldown * 480)), 30, Color.LAWN_GREEN, 5, true)
