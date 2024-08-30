extends Area2D

var damage: float = 100.0
var knockback: float = 1000.0
var stun = 1.5

var timer: float
var exist: bool = false

var player: Node2D

var prev_player_pos: Vector2

var direction: Vector2
var knockback_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	prev_player_pos = player.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	knockback_position = position - (500 * direction)
	timer += delta
	position += direction * 250 * delta
	position += player.position - prev_player_pos
	if timer > 0.2:
		queue_free()
	
	prev_player_pos = player.position
