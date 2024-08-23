extends Area2D

@onready var player: CharacterBody2D

var type: String = "enemy"

var objects_inside: Array = []

var velocity: Vector2
var high_friction_vel: Vector2

var max_speed: float = 750
var speed: float = 250

var damage_to_player: float = 50

var direction

var health := 600.0
var i_frames: float

var stun_time: float

var on_fire: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	queue_redraw()
	
	on_fire -= delta
	
	for item in objects_inside:
		if "passive_damage" in item:
			if "knockback" in item:
				var knock_dir = (position - item.knockback_position).normalized()
				velocity += knock_dir * item.knockback * delta
			if "stun" in item:
				if stun_time < item.stun:
					stun_time = item.stun
			
			if "fire_inflict" in item:
				on_fire = item.fire_inflict
			health -= item.passive_damage * delta
			_health_check()
	
	if on_fire > 0:
		health -= 200 * delta
		_health_check()

func _physics_process(delta: float) -> void:
	
	direction = (position - player.position).normalized()
	
	stun_time -= delta
	i_frames -= delta
	
	#movment calculations
	#friction
	velocity -= velocity / 1 * delta
	high_friction_vel -= high_friction_vel * 4 * delta
	#movment
	if stun_time < 0:
		var next_velocity = velocity + -direction * speed * delta
		var distance_to_max = max_speed - velocity.length()
		var next_distance_to_max = max_speed - next_velocity.length()
		if next_distance_to_max < distance_to_max:
			if distance_to_max > 0:
				velocity += -direction * speed * delta
				if next_distance_to_max < 0:
					velocity = max_speed * -direction
		else:
			velocity += -direction * speed * delta
	
	#move away from other enemies
	for item in objects_inside:
		if "type" in item:
			if item.type == "enemy":
				var collide_dir = (position - item.position).normalized()
				item.velocity += -collide_dir * 2500 * delta
	
	
	#actual movement
	position += (velocity + high_friction_vel) * delta

func _on_area_entered(area: Area2D) -> void:
	objects_inside.append(area)
	if "damage" in area && i_frames < 0:
		if "knockback" in area:
			var knock_dir = (position - area.knockback_position).normalized()
			velocity += knock_dir * area.knockback
		if "stun" in area:
			if stun_time < area.stun:
				stun_time = area.stun
		
		if "fire_inflict" in area:
			on_fire = area.fire_inflict
		health -= area.damage
		_health_check()
		print(health)
		i_frames = 0.15

func _health_check():
	if health <= 0:
		queue_free()


func _on_area_exited(area: Area2D) -> void:
	var area_index
	area_index = objects_inside.find(area, 0)
	objects_inside.remove_at(area_index)

func _draw() -> void:
	draw_line((Vector2(-60, 70)), (Vector2(((health * 0.2) - 60), 70)), Color.GREEN, 16)
	if on_fire > 0:
		draw_line(Vector2(-70, -80), Vector2((on_fire * 80) - 70, -80), Color.RED, 16)
		draw_line(Vector2(-80, -50), Vector2(-80, -40), Color.RED, 16)


func _on_body_entered(body: Node2D) -> void:
	if "type" in body:
		if body.type == "player":
			body._damage_player(damage_to_player)
			var collide_dir = (position - body.position).normalized()
			body.permanent_vel += -collide_dir * 250
