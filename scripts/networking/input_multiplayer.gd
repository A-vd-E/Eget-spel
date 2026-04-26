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
		

		
# RPC:s allow the clients to communicate input to the server
# call_local as argument so the host (both client and server) can
# talk to the itself (client part to server part). If I've understood 
# correctly

# Also add any_peer so that if at some point we decide the client doesn't have authority, we can still call it.
# Which is fine because it only runs on the server anyway.
@rpc("any_peer", "call_local")
func jump():
	if multiplayer.is_server():
		player.do_jump = true
		
		# without a timer, the jump is "stored" if you jump mid-air.
		# Now it only stores for a short time (right before hitting the ground)
		$jump_buffer_timer.start()
		
@rpc("any_peer", "call_local")
func dash():
	
	if multiplayer.is_server():
		player.do_dash = true
			
# To avoid "storing" a jump if jump button pressed mid-air
func _on_jump_buffer_timer_timeout() -> void:
	if multiplayer.is_server():
		player.do_jump = false
