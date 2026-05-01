class_name Enemy extends CharacterBody2D

enum AIState { PATROL, CHASE }

@export var damage:int = 15

@export_group("Movement")
@export var patrol_speed := 100.0
@export var chase_speed := 175.0

@export_group("AI")
@export var chase_distance := 250.0
@export var lose_interest_distance := 350.0 

@export_group("Networking")
@export var correction_strength := 10.0
@export var enemy_id: int

@export var sync_position: Vector2
@export var sync_velocity: Vector2
@export var sync_facing_direction := 1

var current_state: AIState = AIState.PATROL
var target_player: CharacterBody2D = null
var knockback_stun_time_left := 0.0

@onready var health_component: Node2D = $HealthComponent
@onready var damage_area: Area2D = $DamageArea
@onready var damage_timer: Timer = $DamageTimer

@onready var edge_check_left: RayCast2D = $EdgeCheckLeft
@onready var edge_check_right: RayCast2D = $EdgeCheckRight

func _ready() -> void:
	health_component.set_owner_id(enemy_id)
	health_component.died.connect(_on_died)
	
	health_component.knockback_received.connect(_on_knockback_received)
	
	if multiplayer.is_server():
		sync_position = global_position
		damage_area.area_entered.connect(_on_damage_area_entered)
		damage_timer.timeout.connect(_on_damage_timer_timeout)
	else:
		damage_area.monitoring = false

func _physics_process(delta: float) -> void:
	if multiplayer.is_server():
		_server_physics(delta)
	else:
		_apply_network_movement(delta)

func _server_physics(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	# Handle knockback stun state
	if knockback_stun_time_left > 0.0:
		knockback_stun_time_left -= delta
		velocity.x = move_toward(velocity.x, 0, 1000 * delta) # Apply friction
		move_and_slide()
		sync_position = global_position
		sync_velocity = velocity
		return # Skip AI logic while stunned
	
	_evaluate_target_and_state()
	
	match current_state:
		AIState.PATROL:
			_process_patrol_state()
		AIState.CHASE:
			_process_chase_state()
	
	move_and_slide()
	
	sync_position = global_position
	sync_velocity = velocity

func _on_knockback_received(knockback: Vector2) -> void:
	if multiplayer.is_server():
		velocity = knockback
		knockback_stun_time_left = 0.3 # 300ms stun

func _evaluate_target_and_state() -> void:
	var closest_player = _get_closest_player()
	
	if current_state == AIState.PATROL:
		if closest_player and global_position.distance_to(closest_player.global_position) <= chase_distance:
			target_player = closest_player
			current_state = AIState.CHASE
			
	elif current_state == AIState.CHASE:
		if not is_instance_valid(target_player) or global_position.distance_to(target_player.global_position) > lose_interest_distance:
			target_player = null
			current_state = AIState.PATROL

func _process_patrol_state() -> void:
	if is_on_wall() or _is_at_edge():
		_update_facing_direction(sync_facing_direction * -1)
		
	velocity.x = sync_facing_direction * patrol_speed

func _process_chase_state() -> void:
	if not is_instance_valid(target_player):
		return
		
	var direction_to_target = sign(target_player.global_position.x - global_position.x)
	
	if direction_to_target != 0 and direction_to_target != sync_facing_direction:
		_update_facing_direction(direction_to_target)
		
	if _is_at_edge():
		velocity.x = 0
	else:
		velocity.x = sync_facing_direction * chase_speed

## Helper function to cleanly evaluate the correct raycast
func _is_at_edge() -> bool:
	if not is_on_floor():
		return false
		
	if sync_facing_direction == 1:
		return not edge_check_right.is_colliding()
	else:
		return not edge_check_left.is_colliding()

func _update_facing_direction(new_direction: int) -> void:
	if new_direction == 0: return
	sync_facing_direction = sign(new_direction)
	
	$Sprite2D.flip_h = (sync_facing_direction == -1)

func _get_closest_player() -> CharacterBody2D:
	var players_node = get_tree().current_scene.get_node_or_null("Players")
	if not is_instance_valid(players_node):
		return null
		
	var closest: CharacterBody2D = null
	var min_dist := INF
	
	for player in players_node.get_children():
		if player is CharacterBody2D: 
			var dist = global_position.distance_to(player.global_position)
			if dist < min_dist:
				min_dist = dist
				closest = player
				
	return closest

func _on_damage_area_entered(area: Area2D) -> void:
	if not multiplayer.is_server():
		return
	
	if _try_damage(area) and damage_timer.is_stopped():
		damage_timer.start()

func _on_damage_timer_timeout() -> void:
	var hit_anyone := false
	var overlapping_areas = damage_area.get_overlapping_areas()
	
	for area in overlapping_areas:
		if _try_damage(area):
			hit_anyone = true
			
	if not hit_anyone:
		damage_timer.stop()

func _try_damage(area: Area2D) -> bool:
	if area.has_method("receive_hit") and area.get("owner_id") != null:
		if area.owner_id > 0:
			area.receive_hit(damage, Vector2(400, -800), global_position)
			return true
	return false

func _on_died() -> void:
	if multiplayer.is_server():
		queue_free()

func _apply_network_movement(_delta: float) -> void:
	velocity = sync_velocity
	_update_facing_direction(sync_facing_direction)
	
	var drift_distance = global_position.distance_to(sync_position)
	
	if drift_distance > 100.0:
		global_position = sync_position
		reset_physics_interpolation()
	elif drift_distance > 1.0:
		var direction_to_server = sync_position - global_position
		velocity += direction_to_server * correction_strength
	
	move_and_slide()
