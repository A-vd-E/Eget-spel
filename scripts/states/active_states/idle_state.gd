extends State

class_name IdleState


func  _ready():
	allowed_actions = {
		Actions.PlayerAction.MOVE: true,
		Actions.PlayerAction.JUMP: true,
		Actions.PlayerAction.DASH: true,
		Actions.PlayerAction.MELEE: true,
		Actions.PlayerAction.RANGED: true
	}
# For initialization 
func enter():
	#print("Entering idle state")
	pass
	


func physics_update(delta: float):
	
	
	
	character.apply_gravity(delta)
	if character.moving_direction == 0:
		character.velocity.x = move_toward(
			character.velocity.x,
			0, 
			character.SPEED)
	

		
	if character.moving_direction != 0:
		state_machine.change_state("walkstate")
		return



func handle_input(action):
	match action:
		Actions.PlayerAction.DASH:
			state_machine.change_state("dashstate")
		
		Actions.PlayerAction.JUMP:
			if character.buffered_jump and character.is_on_floor() :

				character.buffered_jump = false
				state_machine.change_state("jumpstate")
		
