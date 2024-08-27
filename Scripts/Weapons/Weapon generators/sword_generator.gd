extends Node2D

@export var prefab_1: PackedScene

var weapons_manager: Node2D

var primary_cooldown: float

var game_object: Node2D
var direction: Vector2

var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	primary_cooldown -= delta


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
			inst.position += 100 * direction
			inst.look_at(player.position)
			inst.rotation += deg_to_rad(-90)
			inst.knockback_position = inst.position - (50 * direction)
			game_object.add_child(inst)
