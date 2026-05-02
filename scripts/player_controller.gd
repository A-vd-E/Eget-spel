extends CharacterBody2D

const SPEED := 300.0
const JUMP_VELOCITY := -700.0
const DASH_SPEED := 900.0


@onready var attack_component: Node = $AttackComponent
@onready var input_synchronizer = $InputSynchronizer
@export var sync_position: Vector2
@export var sync_velocity: Vector2
@export var correction_strength := 10.0 # Higher means more aggresive correction
@export var player_id := 1:  # Will match Multiplayer.unique_id
	set(id):
		player_id = id
		# Changed so client only has authority over input, instead of all movement
		$InputSynchronizer.set_multiplayer_authority(id) 

var moving_direction: int
var facing_direction := 1: # Latest facing moving_direction
	set(value):
		if value == 0:
			return
		if facing_direction == value:
			return
		facing_direction = value
		
var do_jump := false # Tells player to jump, updated in InputSynchronizer
var do_dash := false # Tells player to dash, updated in InputSynchronizer
var do_melee_attack := false # Tells player to attack, updated in InputSynchronizer
var do_ranged_attack := false # Tells player to attack, updated in InputSynchronizer
var dashing := false # To check if currently dashing
var can_dash := true # Determines if you can dash, tied to timer

var knockback_stun_time_left := 0.0


func _ready():
	$HealthComponent.set_owner_id(player_id)
	$HealthComponent.knockback_received.connect(_on_knockback_received)
	
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
		moving_direction = input_synchronizer.input_direction
		
		if moving_direction != 0 and knockback_stun_time_left <= 0.0:
			facing_direction = moving_direction
		
		_apply_movement_from_input(delta)
		sync_position = global_position
		sync_velocity = velocity
		
		if do_melee_attack:
			attack_component.attack()
			do_melee_attack = false
			
		if do_ranged_attack:
			attack_component.ranged_attack()
			do_ranged_attack = false
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
	if knockback_stun_time_left > 0.0:
		knockback_stun_time_left -= delta
		if not is_on_floor():
			velocity += get_gravity() * delta
		# Apply friction to slow down horizontal slide
		velocity.x = move_toward(velocity.x, 0, 1000 * delta) 
		move_and_slide()
		return # Exit early so player input is ignored during stun!
	
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
	
	if not dashing:
		if moving_direction:
			velocity.x = moving_direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()
	
func _on_knockback_received(knockback: Vector2) -> void:
	if multiplayer.is_server():
		velocity = knockback
		knockback_stun_time_left = 0.3 # 300 milliseconds of stun
		# Cancel active states
		do_jump = false
		do_dash = false
		dashing = false

func dash():
	dashing = true
	can_dash = false
	# Dash duration
	$dash_timer.start()
	# Dash cooldown
	$dash_again_timer.start()
	velocity.x =  facing_direction * DASH_SPEED 
	
	velocity.y = 0



func _on_dash_timer_timeout() -> void:
	dashing = false


func _on_dash_again_timer_timeout() -> void:
	can_dash = true
