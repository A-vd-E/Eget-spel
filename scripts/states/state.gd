extends Node

class_name State

var state_machine: StateMachine

# For initialization 
func enter():
	pass

# For cleanup
func exit():
	pass
	
# For frame logic
func update(delta: float):
	pass


# For movement
func physics_update(delta: float):
	pass

# For player input
func handle_input(event: InputEvent):
	pass
