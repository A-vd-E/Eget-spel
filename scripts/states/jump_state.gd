extends State
class_name JumpState

func enter():
	#print("Entering jump state")
	
	if character.do_jump and character.is_on_floor() and not character.dashing:
		character.velocity.y = character.JUMP_VELOCITY
		character.do_jump = false
	
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
	if character.do_dash and character.can_dash:
		state_machine.change_state("dashstate")
	
	if character.is_on_floor():
		if character.moving_direction != 0:

			state_machine.change_state(	"walkstate")
			return
		elif character.moving_direction == 0:

			state_machine.change_state(	"idlestate")
			return
