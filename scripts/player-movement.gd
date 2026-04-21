extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -700.0

const DASH_SPEED = 900.0
var dashing = false
var can_dash = true

@export var sync_position: Vector2
@export var lerp_weight = 0.75

func _enter_tree():
		set_multiplayer_authority(name.to_int())

func _ready():
	if is_multiplayer_authority():
		$Camera2D.enabled = true
	else:
		$Camera2D.enabled = false

func _process(delta: float):
	if is_multiplayer_authority():
		sync_position = global_position
	else:
		global_position = global_position.lerp(sync_position, lerp_weight)

func _physics_process(delta: float) -> void:
	if not is_multiplayer_authority(): return
	
	# Add the gravity.
	if not is_on_floor() and !dashing:
		velocity += get_gravity() * delta

	# Handles dash
	if Input.is_action_just_pressed("dash") and can_dash:
		dash()
	
	# Handles basic horizontal movement and jumping
	if not dashing:
		basic_movement()

	move_and_slide()

func basic_movement():
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and !dashing:
		velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
# CURRENT BUG!!!
# The player dashes forward in a straight line, dash is
# then placed on cooldown.
func dash():
	var dash_direction := Input.get_axis("left", "right")
	dashing = true
	can_dash = false
	# Dash duration
	$dash_timer.start()
	# Dash cooldown
	$dash_again_timer.start()
	velocity.x =  dash_direction * DASH_SPEED 
	velocity.y = 0

func _on_dash_timer_timeout() -> void:
	dashing = false


func _on_dash_again_timer_timeout() -> void:
	can_dash = true
