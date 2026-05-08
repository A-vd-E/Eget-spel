extends State

class_name AliveState
	
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
