extends CharacterBody2D


const SPEED = 200.0
var max_speed := 800.0
var move_vel := Vector2(0, 0)

func _physics_process(delta):
	velocity = Vector2(0, 0)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = (Vector2(input_dir.x, input_dir.y)).normalized()
	if direction:
		#print("moving")
		move_vel += direction * SPEED
	if !direction.x:
		#print("x")
		#change the value of 0 to be dynamic and how the rest of this works so that controller works betters?
		move_vel.x = move_toward(move_vel.x, 0, SPEED)
	if !direction.y:
		#print("y")
		move_vel.y = move_toward(move_vel.y, 0, SPEED)	
	
	var current_speed = move_vel.length()
	if current_speed > max_speed:
		move_vel = max_speed * move_vel.normalized()

	
	#print(move_vel)
	velocity = (move_vel)
	move_and_slide()
