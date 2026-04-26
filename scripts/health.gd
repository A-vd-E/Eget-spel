extends Node2D

@export var max_health: int = 100
@export var sync_health: int:
	set(value):
		sync_health = value
		health_changed.emit(value)




signal health_changed(new_value: int)
signal died

# Starts character with full health
func _ready() -> void:
	if is_multiplayer_authority():
		
		sync_health = max_health
		
	

## Decreases the characters health by the input amount.
@rpc "call_local"
func take_damage(damage: int):
	
		
		sync_health = max(sync_health - damage, 0)

		
		if sync_health == 0:
			dies()
	
# Reduces health when "L" key is pressed. For testing purposes.
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("decrease_hp") and not event.is_echo() :
		take_damage(10)

func dies():
	died.emit()


	
