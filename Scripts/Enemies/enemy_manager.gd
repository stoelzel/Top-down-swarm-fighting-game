extends Node2D

@export var enemy_1_prefab: PackedScene

@onready var player = %Player

var active: bool = true

var timer: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if active == true:
		timer += delta
	if timer > 1:
		timer = 0
		var inst = enemy_1_prefab.instantiate()
		inst.position.x = randf_range((-1000 + player.position.x), (1000 + player.position.x))
		inst.position.y = randf_range((-1000 + player.position.y), (1000 + player.position.y))
		
		inst.player = player
		owner.add_child(inst)
