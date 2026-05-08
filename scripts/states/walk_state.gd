extends State
class_name WalkState

func enter():
	#print("Entering walk state")
	pass
# For movement
func physics_update(delta: float):
	
	if character.movement_locked:
		state_machine.change_state("idlestate")
		return
	
	if not character.is_on_floor():
		character.apply_gravity(delta)
	
	if character.moving_direction == 0:
		state_machine.change_state("idlestate")
		return
	
	if character.do_jump and character.is_on_floor():
		state_machine.change_state("jumpstate")
		return
	
	if character.do_dash and character.can_dash:
		state_machine.change_state("dashstate")
	
	if character.moving_direction:
		character.velocity.x = character.moving_direction * character.SPEED
	
