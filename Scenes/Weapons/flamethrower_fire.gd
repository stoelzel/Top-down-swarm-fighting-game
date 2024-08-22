extends Area2D

var speed: float = 700.0
var speed_fac: float

var damage: float = 0.0
var passive_damage: float = 300.0
var knockback: float = 0.0
var stun: float = 0.0

var timer: float
var exist: bool = false

var knockback_position: Vector2

var effects: Array = ["fire"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	speed_fac = randf_range(0.9, 1.1)
	scale.x = 0.1
	scale.y = 0.1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction = (position - $Marker2D.global_position).normalized()
	position += direction * delta * speed
	
	scale.x = (timer / 1.5) + 0.1
	scale.y = (timer / 1.5) + 0.1
	
	speed = 450 - (timer * 250) * speed_fac
	
	timer += delta
	if timer > 1:
		if exist == true:
			queue_free()
	exist = true
