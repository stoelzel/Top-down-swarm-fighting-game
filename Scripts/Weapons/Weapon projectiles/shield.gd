extends Area2D

var damage: float = 30.0
var knockback: float = 500.0


var timer: float
var exist: bool = false

var knockback_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if exist == true:
		queue_free()
	exist = true
	visible = false
