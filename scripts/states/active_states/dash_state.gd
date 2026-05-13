extends State

class_name DashState

@export var dash_distance := 240.0
@export var dash_duration := 0.20

var elapsed := 0.0
var start_position := Vector2.ZERO
var dash_speed := 0.0


func _ready():
	allowed_actions = {
		Actions.PlayerAction.MOVE: false,
		Actions.PlayerAction.JUMP: false,
		Actions.PlayerAction.DASH: false,
		Actions.PlayerAction.MELEE: false,
		Actions.PlayerAction.RANGED: false
	}


func enter():

	elapsed = 0.0
	start_position = character.global_position

	dash_speed = dash_distance / dash_duration

	character.can_dash = false
	character.add_turn_lock("dash")

	$dash_again_timer.start()


func physics_update(delta: float):

	if character.movement_locked:
		end_dash()
		return

	elapsed += delta

	character.velocity.x = (
		character.facing_direction
		* dash_speed
	)

	character.velocity.y = 0

	# End by time
	if elapsed >= dash_duration:
		end_dash()
		return

	# Optional wall cancel
	if character.is_on_wall() and not character.is_on_floor():
		end_dash()


func end_dash():

	character.velocity.x = 0

	character.remove_turn_lock("dash")

	state_machine.change_state("idlestate")


func _on_dash_again_timer_timeout():
	character.can_dash = true
	$dash_again_timer.stop()
