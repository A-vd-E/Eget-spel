extends State

class_name DeathState

func  _ready():
	allowed_actions = {
		Actions.PlayerAction.MOVE: false,
		Actions.PlayerAction.JUMP: false,
		Actions.PlayerAction.DASH: false,
		Actions.PlayerAction.MELEE: false,
		Actions.PlayerAction.RANGED: false
	}
	
# For initialization 
func enter():
	
	print("Entering death state")
	
	character.movement_locked = true
	character.lock_turning = true
	print(character.lock_turning)
	$automatic_revival_timer.start()
	print("SERVER:", multiplayer.is_server(), " LOCK:", character.lock_turning)
	
func exit(): 
	pass
func physics_update(delta: float):
	print(character.lock_turning)

func _on_automatic_revival_timer_timeout() -> void:
	$automatic_revival_timer.stop()
	var health = character.get_node("HealthComponent")
	health.respawn()
	state_machine.change_state("alivestate")
