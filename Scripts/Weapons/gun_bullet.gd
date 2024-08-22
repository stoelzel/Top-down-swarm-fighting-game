extends Area2D

var speed: float = 800.0

var damage: float = 300.0
var knockback: float = 300.0
var stun: float = 0.25

var timer: float
var exist: bool = false

var knockback_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction = (position - $Marker2D.global_position).normalized()
	position += direction * delta * speed
	
	timer += delta
	if timer > 10:
		if exist == true:
			queue_free()
	exist = true
