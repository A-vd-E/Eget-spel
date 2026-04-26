extends CharacterBody2D

const SPEED := 300.0
const JUMP_VELOCITY := -700.0
const DASH_SPEED := 900.0


@onready var input_synchronizer = $InputSynchronizer
#@export var sync_position: Vector2   Will still be used for lerp?
#@export var lerp_weight := 0.75      Will still be used for lerp?


# This player_id could probably be replaced. But tutorial did 
# it this way and it works, so won't change it right now
@export var player_id := 1:  
	set(id):
		player_id = id
		# Changed so client only has authority over input, instead of all movement
		$InputSynchronizer.set_multiplayer_authority(id) 


var direction: int
var do_jump := false # Tells player to jump, updated in InputSynchronizer
var do_dash := false # Tells player to dash, updated in InputSynchronizer

var dashing := false # To check if currently dashing
var can_dash := true # Determines if you can dash, tied to timer


# Changed so client only has authority over input, instead of all movement
#func _enter_tree():
		#set_multiplayer_authority(name.to_int()) Should be removed

func _ready():
	
 	# Only the client player has a camera enabled, so always 
	# follows the playable characther
	if multiplayer.get_unique_id() == player_id:
		$Camera2D.enabled = true
	else:
		$Camera2D.enabled = false
	pass
	
# Haven't understood lerp yet so wont touch, but will probably
# need to be reworked to acommodate new logic
#func _process(_delta: float):  
	#if is_multiplayer_authority():
		#sync_position = global_position
	#else:
		#global_position = global_position.lerp(sync_position, lerp_weight)

# Moved most things to _apply_movement_from_input
func _physics_process(delta: float) -> void:
	if multiplayer.is_server(): 
		_apply_movement_from_input(delta)
		
	


## Manages basic movement, namely jumping and walking.
func _apply_movement_from_input(delta):
	
	# Handles gravity
	if not is_on_floor() and not dashing:
		velocity += get_gravity() * delta
	
	# Handles jump.
	if do_jump and is_on_floor() and not dashing:
		velocity.y = JUMP_VELOCITY
		do_jump = false
	
	# Handles dashing
	if do_dash and can_dash:
		dash()
		do_dash = false
	
	
	# Handles regular left/right movement based on input direction
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
	
	var dash_direction: int = input_synchronizer.input_direction
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
