extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@export var hitbox_shape: Shape2D


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
func _input(event: InputEvent) -> void:
	
	
	if event.is_action_pressed("attack") and not event.is_echo():
		var hitbox = Hitbox.new(20, 5.0, hitbox_shape)
		add_child(hitbox)
