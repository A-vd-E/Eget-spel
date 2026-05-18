extends State
class_name JumpState


var wants_wall_jump := false


func  _ready():
	allowed_actions = {
		Actions.PlayerAction.MOVE: true,
		Actions.PlayerAction.JUMP: true,
		Actions.PlayerAction.DASH: true,
		Actions.PlayerAction.MELEE: true,
		Actions.PlayerAction.RANGED: true
	}
	

func enter():

	

	wants_wall_jump = false
	# Jump
	if character.is_on_floor():
		character.velocity.y = character.JUMP_VELOCITY
		
	
func physics_update(delta: float):
	
	
	character.apply_gravity(delta)
	
	if character.velocity.y >= 0:
		state_machine.change_state("fallstate")
		return
	
	
	
	# Allows horizontal movement
	if character.moving_direction:
		character.velocity.x = character.moving_direction * character.SPEED
	# Slow down horizontaly if no horizontal movement
	if character.moving_direction == 0:
		character.velocity.x = move_toward(
			character.velocity.x,
			0, 
			character.SPEED)
	
	
	
	## Wall slide
	#if character.is_on_wall() and !character.is_on_floor() and character.velocity.y > 0:
		#character.velocity.y = min(character.velocity.y, character.WALL_SLIDE_SPEED)
	#
	# Wall jump 
	if wants_wall_jump: 
		if character.is_on_wall():	
				print("walljump test, in falling")
				wants_wall_jump = false
				state_machine.change_state("walljumpstate")
				return
			

func handle_input(action):
	match action:
		Actions.PlayerAction.DASH:
			state_machine.change_state("dashstate")
			
		Actions.PlayerAction.JUMP:
			# WALL JUMP
			wants_wall_jump = true
			$wall_jump_buffer_timer.start()
				
			
	


func _on_wall_jump_buffer_timer_timeout() -> void:
	wants_wall_jump = false
	$wall_jump_buffer_timer.stop()
