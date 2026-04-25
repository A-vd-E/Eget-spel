extends MultiplayerSynchronizer

@onready var player: CharacterBody2D = $".."
var input_direction: int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	input_direction = Input.get_axis("left", "right")
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		set_process(false)
		set_physics_process(false)

func _physics_process(delta: float) -> void:
	input_direction = Input.get_axis("left", "right")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		jump.rpc()
	
	if Input.is_action_just_pressed("dash"):
		dash.rpc()
		
@rpc("call_local")
func jump():
	if multiplayer.is_server():
		player.do_jump = true
		
@rpc("call_local")
func dash():
	print("first")
	if multiplayer.is_server():
		player.do_dash = true
		print("second")
