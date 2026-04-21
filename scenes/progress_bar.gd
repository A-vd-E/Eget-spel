extends ProgressBar

@export var health: Node 


func _ready() -> void:
	max_value = health.max_health
	value = health.max_health
	health.health_changed.connect(_on_health_changed)

func _on_health_changed(current_health: int):
	value = current_health
