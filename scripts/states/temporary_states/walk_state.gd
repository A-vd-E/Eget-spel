extends State
class_name WalkState

func  _ready():
	allowed_actions = {
		Actions.PlayerAction.MOVE: true,
		Actions.PlayerAction.JUMP: true,
		Actions.PlayerAction.DASH: true,
		Actions.PlayerAction.MELEE: true,
		Actions.PlayerAction.RANGED: true
	}


# For movement
func physics_update(delta: float):
	
	if character.movement_locked:
		state_machine.change_state("idlestate")
		return
	
	if not character.is_on_floor():
		state_machine.change_state("fallstate")
	
	if character.moving_direction == 0:
		state_machine.change_state("idlestate")
		return
	
	
	if character.moving_direction:
		character.velocity.x = character.moving_direction * character.SPEED
	
func handle_input(action):
	match action:
		Actions.PlayerAction.DASH:
			state_machine.change_state("dashstate")
			
		Actions.PlayerAction.JUMP:
			if character.buffered_jump and character.is_on_floor() :

				character.buffered_jump = false
				state_machine.change_state("jumpstate")
		
