extends Hitbox
class_name StaticHazard

@export var hazard_damage: int = 50
@export var hazard_knockback: Vector2 = Vector2(0, -800) # Knocks straight up

func _ready() -> void:
	super._ready() # Calls the base Hitbox _ready() which connects the area_entered signal
	
	# Assign the values the base Hitbox expects
	attacker_dmg = hazard_damage
	knockback_vector = hazard_knockback
	attacker_id = -1000 # A generic ID so it doesn't match any player's ID
	
	# Note: We intentionally DO NOT call start_lifetime() here 
	# because we want this hazard to stay in the level forever!
