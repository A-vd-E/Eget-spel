extends Node


@export var max_health: int = 100
var current_health

signal health_changed(new_value: int)
signal died

# Starts character with full health
func _ready() -> void:
	current_health = max_health
	

## Decreases the characters health by the input amount.
func take_damage(damage: int):
	if damage <= 0:
		return
		
	current_health = max(current_health - damage, 0)
	health_changed.emit(current_health)
	print(current_health)
	if current_health == 0:
		dies()
		
# Reduces health when "L" key is pressed. For testing purposes.
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("decrease_hp") and not event.is_echo():
		take_damage(10)
		
func dies():
	died.emit()
	await get_tree().create_timer(5.0).timeout
	get_tree().quit()
