extends State

class_name IdleState
	
# For initialization 
func enter():
	print("Entering idle state")
	


func physics_update(delta: float):
	
	character.apply_gravity(delta)
	if character.moving_direction == 0:
		character.velocity.x = move_toward(
			character.velocity.x,
			0, 
			character.SPEED)
	
	
	# Transition to walk
	if character.moving_direction != 0:
		state_machine.change_state("walkstate")
		return

	# Transition to jump
	if character.do_jump and character.is_on_floor():
		state_machine.change_state("jumpstate")
	
	if character.do_dash and character.can_dash:
		state_machine.change_state("dashstate")
	
