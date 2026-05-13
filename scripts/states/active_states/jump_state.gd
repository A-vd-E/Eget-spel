extends State
class_name JumpState

func  _ready():
	allowed_actions = {
		Actions.PlayerAction.MOVE: true,
		Actions.PlayerAction.JUMP: false,
		Actions.PlayerAction.DASH: true,
		Actions.PlayerAction.MELEE: true,
		Actions.PlayerAction.RANGED: true
	}

func enter():
	#print("Entering jump state")
	
	if character.is_on_floor():
		character.velocity.y = character.JUMP_VELOCITY
		
	
func physics_update(delta: float):
	
	if character.movement_locked:
		state_machine.change_state("idlestate")
		return
	
	character.apply_gravity(delta)
	if character.moving_direction:
		character.velocity.x = character.moving_direction * character.SPEED
	
	# Handles jump.
	
	
	if character.moving_direction == 0:
		character.velocity.x = move_toward(
			character.velocity.x,
			0, 
			character.SPEED)
	
	if character.is_on_floor():
		if character.moving_direction != 0:

			state_machine.change_state(	"walkstate")
			return
		elif character.moving_direction == 0:

			state_machine.change_state(	"idlestate")
			return

func handle_input(action):
	match action:
		Actions.PlayerAction.DASH:
			state_machine.change_state("dashstate")
			
		
	
