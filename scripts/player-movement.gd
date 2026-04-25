extends CharacterBody2D


const SPEED := 300.0
const JUMP_VELOCITY := -700.0

const DASH_SPEED := 900.0
var dashing := false
var can_dash := true

@onready var input_synchronizer = $InputSynchronizer
#@export var sync_position: Vector2
@export var lerp_weight := 0.75
@export var hitbox_shape: Shape2D
@export var player_id := 1:
	set(id):
		player_id = id
		$InputSynchronizer.set_multiplayer_authority(id)


var direction: int
var do_jump := false
var do_dash := false
var _is_on_floor := true

#func _enter_tree():
		#set_multiplayer_authority(name.to_int())

func _ready():
	
	#if is_multiplayer_authority():
		#$Camera2D.enabled = true
	#else:
		#$Camera2D.enabled = false
	pass
#func _process(_delta: float):
	#if is_multiplayer_authority():
		#sync_position = global_position
	#else:
		#global_position = global_position.lerp(sync_position, lerp_weight)

func _physics_process(delta: float) -> void:
	if multiplayer.is_server(): 
		_apply_movement_from_input(delta)
	
func _input(event: InputEvent) -> void:
	
	
	
	if event.is_action_pressed("attack") and not event.is_echo():
		var hitbox = Hitbox.new(20, 5.0, hitbox_shape)
		add_child(hitbox)

## Manages basic movement, namely jumping and walking.
func _apply_movement_from_input(delta):
	
	if not is_on_floor() and not dashing:
		velocity += get_gravity() * delta
	# Handle jump.
	if do_jump and is_on_floor() and not dashing:
		velocity.y = JUMP_VELOCITY
		do_jump = false
	
	if do_dash and can_dash:
		print("third")
		dash()
		
		do_dash = false
	
	
	# Get the input direction and handle the movement/deceleration.
	direction = input_synchronizer.input_direction
	
	if not dashing:
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()
# CURRENT BUG!!!
## The player dashes forward in a straight line, dash is
## then placed on cooldown.
func dash():
	print("fourth")
	var dash_direction: int = input_synchronizer.input_direction
	dashing = true
	can_dash = false
	# Dash duration
	$dash_timer.start()
	# Dash cooldown
	$dash_again_timer.start()
	velocity.x =  dash_direction * DASH_SPEED 
	print("fourth")
	velocity.y = 0



func _on_dash_timer_timeout() -> void:
	dashing = false


func _on_dash_again_timer_timeout() -> void:
	can_dash = true
