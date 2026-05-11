extends Node

class_name State



var state_machine: StateMachine
var character:
	get:
		return state_machine.get_parent()
var allowed_actions := {}

func can(action: Actions.PlayerAction) -> bool:

	return allowed_actions.get(action, false)
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
func handle_input(action: Actions.PlayerAction):
	pass
