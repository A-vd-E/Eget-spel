extends Node

class_name  StateMachine

@export var initial_state: State
var current_state: State
var states: Dictionary = {}

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.state_machine = self

	if initial_state:
		change_state(initial_state.name.to_lower())
# Called every frame. 'delta' is the elapsed time since the previous frame.
func update(delta: float) -> void:
	if current_state:
		current_state.update(delta)
	
func physics_update(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)
	

func change_state(new_state_name: String) -> void:
	
	var new_state = states.get(new_state_name.to_lower())
	
	if current_state == new_state:
		return
	if current_state:
		current_state.exit()
		
	current_state = new_state
	
	
	if current_state:
		current_state.enter()
