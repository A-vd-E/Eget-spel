extends CharacterBody2D

const SPEED := 300.0
const JUMP_VELOCITY := -700.0
const DASH_SPEED := 900.0


@onready var attack_component: Node = $AttackComponent
@onready var input_synchronizer = $InputSynchronizer
@onready var animation_player = $AnimationPlayer
@onready var visuals = $Visuals
@onready var actions_state_machine = $ActionsStateMachine
@onready var status_state_machine = $StatusStateMachine
@export var sync_position: Vector2
@export var sync_velocity: Vector2
@export var respawn_point: Vector2 = Vector2(0, 0)
@export var correction_strength := 10.0 # Higher means more aggresive correction
@export var player_id := 1:  # Will match Multiplayer.unique_id
	set(id):
		player_id = id
		# Changed so client only has authority over input, instead of all movement
		$InputSynchronizer.set_multiplayer_authority(id) 

var moving_direction: int
@export var facing_direction := 1: # Latest facing moving_direction
	set(value):
		if movement_locked:
			return
		if value == 0:
			return
		if facing_direction == value:
			return
		facing_direction = value
		
var buffered_jump := false
var do_dash := false # Tells player to dash, updated in InputSynchronizer
var do_melee_attack := false # Tells player to attack, updated in InputSynchronizer
var do_ranged_attack := false # Tells player to attack, updated in InputSynchronizer
var dashing := false # To check if currently dashing
var can_dash := true # Determines if you can dash, tied to timer
var movement_locked := false
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

func _process(delta: float) -> void:
	if facing_direction == -1:
		visuals.scale.x = -1
	elif facing_direction == 1:
		visuals.scale.x = 1
	

# Moved most things to _apply_movement_from_input
func _physics_process(delta: float) -> void:
	if multiplayer.is_server(): 
		moving_direction = input_synchronizer.input_direction
		
		if moving_direction != 0 and knockback_stun_time_left <= 0.0:
			facing_direction = moving_direction
			
		#try_jump()
		
		actions_state_machine.physics_update(delta)
		
		_apply_movement_from_input(delta)
		move_and_slide()
		sync_position = global_position
		sync_velocity = velocity
		
		if do_melee_attack:
			attack_component.melee_attack()
			rpc_play_animation.rpc("melee_attack")
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
	
	
	
func _on_knockback_received(knockback: Vector2) -> void:
	if multiplayer.is_server():
		velocity = knockback
		knockback_stun_time_left = 0.3 # 300 milliseconds of stun
		# Cancel active states
		
		do_dash = false
		dashing = false
		
@rpc("call_local", "authority", "reliable")
func rpc_play_animation(anim_name: String):
	animation_player.play(anim_name)


func apply_gravity(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta

func handle_action(action: Actions.PlayerAction):
	if not can_perform(action):
		return
	actions_state_machine.current_state.handle_input(action)
func can_perform(action: Actions.PlayerAction) -> bool:
	#var action_allowed = actions_state_machine.current_state.can(action)
	#var status_allowed = status_state_machine.current_state.can(action)
#
	#print("Action:", action_allowed)
	#print("Status:", status_allowed)
#
	#return action_allowed and status_allowed
	
	#print("Works here 1")
	return (
		actions_state_machine.current_state.can(action)
		and
		status_state_machine.current_state.can(action)
	)
# Since jumps are buffered to improve game feel, they are 
# 
func try_jump():
	if buffered_jump and is_on_floor() :

			buffered_jump = false
			actions_state_machine.change_state("jumpstate")
