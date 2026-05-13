extends MultiplayerSynchronizer

@onready var player: CharacterBody2D = $".."
var input_direction: float

func _ready() -> void:
	
	input_direction = Input.get_axis("left", "right")
	
	# This ensures that only the client (one in control of playable
	# chatacter) runs the processes, thereby registering input. 
	# Without this we would get double input from both players 
	# in the scene (but like yanky and inconsistent)
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		set_process(false)
		set_physics_process(false)

# input_direction under _physics_process for predictability in movement
func _physics_process(delta: float) -> void:
	input_direction = Input.get_axis("left", "right")

# Rpc calls placed under _process for precision/reduce lag 
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		jump.rpc_id(1)
		
	if Input.is_action_just_pressed("dash"):
		dash.rpc_id(1)
		
	if Input.is_action_just_pressed("melee_attack"):
		melee_attack.rpc_id(1)

	if Input.is_action_just_pressed("ranged_attack"):
		ranged_attack.rpc_id(1)

# RPC:s allow the clients to communicate input to the server
# call_local as argument so the host (both client and server) can
# talk to the itself (client part to server part). If I've understood 
# correctly

# Also add any_peer so that if at some point we decide the client doesn't have authority, we can still call it.
# Which is fine because it only runs on the server anyway.
@rpc("any_peer", "call_local")
func jump():
	if multiplayer.is_server():
		
		if player.can_perform(Actions.PlayerAction.JUMP):
			
			player.buffered_jump = true
			#To store jumps for a slight duration, allows for smoother game feel
			$jump_buffer_timer.start()
			player.handle_action(Actions.PlayerAction.JUMP)
		
@rpc("any_peer", "call_local")
func dash():
	if multiplayer.is_server():

		if player.can_perform(Actions.PlayerAction.DASH):
			if player.dash_on_cooldown:
				return
			if not player.is_on_floor() and !player.can_dash_in_air:
				return
			player.handle_action(Actions.PlayerAction.DASH)
			#player.do_dash = true
@rpc("call_local", "any_peer")
func melee_attack():
	if multiplayer.is_server():
		if player.can_perform(Actions.PlayerAction.MELEE):
			player.do_melee_attack = true
		
@rpc("call_local", "any_peer")
func ranged_attack():
	if multiplayer.is_server():
		
		if player.can_perform(Actions.PlayerAction.RANGED):
			player.do_ranged_attack = true		
# To avoid "storing" a jump if jump button pressed mid-air
func _on_jump_buffer_timer_timeout() -> void:
	if multiplayer.is_server():
		player.buffered_jump = false
