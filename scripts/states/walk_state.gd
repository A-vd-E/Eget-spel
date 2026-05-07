extends State
class_name WalkState

func enter():
	print("Entering walk state")

# For movement
func physics_update(delta: float):
	var character = state_machine.get_parent()
	var direction = Input.get_axis("left", "right")
	
	if direction == 0:
		state_machine.change_state("idlestate")
		return

func handle_input(event: InputEvent):
	if Input.is_action_pressed("jump"):
		state_machine.change_state("jumpstate")
