extends Area2D

var damage: float = 300.0
var passive_damage: float = 100.0
var knockback: float = 1000.0
var stun: float = 0.0

var timer: float
var exist: bool = false

var knockback_position: Vector2

var fire_inflict: float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if exist == true:
		damage = 0
	timer += delta
	if timer > 0.2:
		if exist == true:
			queue_free()
	exist = true
