extends State
class_name JumpState

func enter():
	print("Entering jump state")
	var character = state_machine.get_parent()
	
	
func physics_update(delta: float):
	var character = state_machine.get_parent()
	
	var direction = Input.get_axis("left", "right")
	
	if character.is_on_floor():
		if direction != 0:
			state_machine.change_state(	"walkstate")
		elif direction == 0:
			print("Test why")
			state_machine.change_state(	"idlestate")
