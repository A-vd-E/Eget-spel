extends State
class_name WallJumpState

var wants_wall_jump := false
var wall_jump_locked := false

func  _ready():
	allowed_actions = {
		Actions.PlayerAction.MOVE: false,
		Actions.PlayerAction.JUMP: false,
		Actions.PlayerAction.DASH: false,
		Actions.PlayerAction.MELEE: false,
		Actions.PlayerAction.RANGED: false
	}
	

func enter():
	
	print("enter wall jump")
	character.can_dash_in_air = true
	wall_jump_locked = true
				
	var wall_normal = character.get_wall_normal()

	character.velocity.y = character.WALL_JUMP_FORCE_Y
	character.velocity.x = wall_normal.x * character.WALL_JUMP_FORCE_X
				
	wants_wall_jump = false
	$wall_jump_timer.start()
	
func physics_update(delta: float):
	
	
	
	character.apply_gravity(delta)
	
	

func handle_input(action):
	match action:
		Actions.PlayerAction.DASH:
			state_machine.change_state("dashstate")
			
			
	

func _on_wall_jump_timer_timeout() -> void:
	wall_jump_locked = false
	
	$wall_jump_timer.stop()
	state_machine.change_state("fallstate")
