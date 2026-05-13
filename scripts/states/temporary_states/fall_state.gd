extends State
class_name FallState

var wants_wall_jump := false
var fall_gravity_multiplier := 1.3


func  _ready():
	allowed_actions = {
		Actions.PlayerAction.MOVE: true,
		Actions.PlayerAction.JUMP: true,
		Actions.PlayerAction.DASH: true,
		Actions.PlayerAction.MELEE: true,
		Actions.PlayerAction.RANGED: true
	}
	
func enter():
	print("enter fall")
	wants_wall_jump = false
	
func physics_update(delta: float):
	

	
	fall_gravity(delta)
	

	# Allows horizontal movement
	if character.moving_direction:
		character.velocity.x = character.moving_direction * character.SPEED
	
		
	# Slow down horizontaly if no horizontal movement
	if character.moving_direction == 0:
		character.velocity.x = move_toward(
			character.velocity.x,
			0, 
			character.SPEED)
	
	
	# Wall slide
	if character.is_on_wall() and !character.is_on_floor() and character.velocity.y > 0:
		character.velocity.y = min(character.velocity.y, character.WALL_SLIDE_SPEED)
	
	# Wall jump 
	if wants_wall_jump: 
		if character.is_on_wall():	
				wants_wall_jump = false
				state_machine.change_state("walljumpstate")
				return
				
				
	# Landing transition
	if character.is_on_floor():
		if character.moving_direction != 0:
			character.can_dash_in_air = true
			state_machine.change_state(	"walkstate")
			return
		elif character.moving_direction == 0:
			character.can_dash_in_air = true
			state_machine.change_state(	"idlestate")
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

func fall_gravity(delta):
	character.velocity += character.get_gravity() * delta * fall_gravity_multiplier
