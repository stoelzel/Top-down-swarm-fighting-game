extends Area2D

@export var prefab_1: PackedScene

var speed: float = 800.0

var game_object: Node2D

var has_collided: bool

var damage: float = 600.0
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
	knockback_position = position
	
	if has_collided == true:
		var inst = prefab_1.instantiate()
		inst.position = position
		inst.knockback_position = position
		game_object.add_child(inst)
		queue_free()
	
	timer += delta
	if timer > 10:
		if exist == true:
			queue_free()
	exist = true


func _on_area_entered(area: Area2D) -> void:
	if "type" in area:
		if area.type == "enemy":
			has_collided = true
