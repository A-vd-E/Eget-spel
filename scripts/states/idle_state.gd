extends State

class_name IdleState
	
# For initialization 
func enter():
	print("Entering idle state")


# For player input
func handle_input(event: InputEvent):
	if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		state_machine.change_state("walkstate")
	elif Input.is_action_pressed("jump"):
		state_machine.change_state("jumpstate")
		
