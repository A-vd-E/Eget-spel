extends State

class_name AliveState

func  _ready():
	allowed_actions = {
		Actions.PlayerAction.MOVE: true,
		Actions.PlayerAction.JUMP: true,
		Actions.PlayerAction.DASH: true,
		Actions.PlayerAction.MELEE: true,
		Actions.PlayerAction.RANGED: true
	}
# For initialization 
func enter():
	print("Entering alive state")
	character.movement_locked = false
	
	var health = character.get_node("HealthComponent")
	if not health.died.is_connected(death):
		health.died.connect(death)
	if is_multiplayer_authority():
		
		health.sync_health = health.max_health

func death():
	state_machine.change_state("deathstate")
