extends CharacterBody2D

const SPEED := 300.0
const JUMP_VELOCITY := -700.0
const DASH_SPEED := 900.0


@onready var attack_component: Node = $AttackComponent
@onready var input_synchronizer = $InputSynchronizer
@export var sync_position: Vector2
@export var sync_velocity: Vector2
@export var correction_strength := 10.0 # Higher means more aggresive correction



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
var do_attack := false # Tells player to attack, updated in InputSynchronizer
var dashing := false # To check if currently dashing
var can_dash := true # Determines if you can dash, tied to timer



func _ready():
	

	$HealthComponent.set_owner_id(player_id)
	
 	# Only the client player has a camera enabled, so always 
	# follows the playable characther
	if multiplayer.get_unique_id() == player_id:
		$Camera2D.enabled = true
	else:
		$Camera2D.enabled = false
	
	sync_position = global_position
	

# Moved most things to _apply_movement_from_input
func _physics_process(delta: float) -> void:
	if multiplayer.is_server(): 
		_apply_movement_from_input(delta)
		sync_position = global_position
		sync_velocity = velocity
		
		if do_attack:
			print("Player:",player_id, " called attack. Test 1 In Player")
			attack_component.attack()
			do_attack = false
	else:
		_apply_network_movement(delta)
		
	
func _apply_network_movement(_delta):
	# Base velocity follows the server
	velocity = sync_velocity
	
	var drift_distance = global_position.distance_to(sync_position)
	
	if drift_distance > 100.0:
		# Massive lag spike, snap to server
		global_position = sync_position
		reset_physics_interpolation()
	elif drift_distance > 1.0:
		# Slight drift, steer toward server
		var direction_to_server = sync_position - global_position
		velocity += direction_to_server * correction_strength
	
	move_and_slide()

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
