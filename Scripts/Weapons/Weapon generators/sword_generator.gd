extends Node2D

@export var prefab_1: PackedScene
@export var prefab_2: PackedScene

var weapons_manager: Node2D

var primary_cooldown: float
var secondary_cooldown: float

var game_object: Node2D
var direction: Vector2

var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	primary_cooldown -= delta
	secondary_cooldown -= delta
	
	queue_redraw()


func _manager_add(stored_weapon):
	if stored_weapon == 1:
		weapons_manager.stored_weapon_1 = self
	if stored_weapon == 2:
		weapons_manager.stored_weapon_2 = self


func _attack_primary(delta: float) -> void:
	if Input.is_action_just_pressed("primary_action"):
		if primary_cooldown < 0:
			primary_cooldown = 0.3
			var inst = prefab_1.instantiate()
			inst.position = player.position
			inst.look_at(inst.position + direction)
			inst.rotation += deg_to_rad(50)
			inst.player = player
			game_object.add_child(inst)


func _attack_secondary(delta: float) -> void:
	if Input.is_action_just_pressed("secondary_action"):
		if secondary_cooldown < 0:
			secondary_cooldown = 1
			var inst = prefab_2.instantiate()
			inst.position = player.position
			inst.look_at(inst.position + direction)
			inst.rotation += deg_to_rad(90)
			inst.player = player
			game_object.add_child(inst)


func _draw() -> void:
	if weapons_manager.equiped_weapon == self:
		if player != null:
			draw_arc(player.global_position, 100, 0, deg_to_rad(360 - (primary_cooldown * 1200)), 30, Color.CYAN, 5, true)
			draw_arc(player.global_position, 120, 0, deg_to_rad(360 - (secondary_cooldown * 360)), 30, Color.LAWN_GREEN, 5, true)
