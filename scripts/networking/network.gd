extends Node

const PORT: int = 42069
var player_scene = preload("res://scenes/player.tscn")
var enemy_scene = preload("res://scenes/enemy.tscn")

# Changed name to describe its function, and moved to _on_host_button_pressed()
# so that only the host's/server's sceneTree is the spawnpoint. 
# Then clients will then sync that, instead of generating their own from scratch.
# This is to avoid syncing problems/data races (I think... or might not do anything).

#@onready var world = get_node("../World") Removed
var _player_spawn_node #Replacement
var _enemy_spawn_node
var _enemy_id_counter := -1

# Moved logic to "Main" node instead of in networking

#@onready var host_button = get_node("../CanvasLayer/VBoxContainer/HostButton")
#@onready var join_button = get_node("../CanvasLayer/VBoxContainer/JoinButton")
var ip_input


func _ready():
	# Moved this to become_host so the server is in charge of player connections
	#multiplayer.peer_disconnected.connect(remove_player)
	#multiplayer.server_disconnected.connect(_on_server_disconnected)
	pass

func _become_host() -> void:
	print("Starting host")
	_player_spawn_node = get_tree().current_scene.get_node("SpawningContainers").get_node("Players")
	_enemy_spawn_node = get_tree().current_scene.get_node("SpawningContainers").get_node("Enemies")
	
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	
	multiplayer.multiplayer_peer = peer
	
	multiplayer.peer_connected.connect(_add_player)
	multiplayer.peer_disconnected.connect(remove_player)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	
	
	_add_player(multiplayer.get_unique_id())
	
	_spawn_enemy(Vector2(-400, 300)) # temporary positions and spawns
	_spawn_enemy(Vector2(500, 100))
	
func _join_as_non_host_client(ip_input) -> void:
	print("Joining as client")
	
	var input_text = ip_input
	if input_text == "":
		input_text = "localhost:42069" # Default
	
	# Split the input into Address and Port
	# Expects format "address:port" (e.g. orange-tree.playit.gg:54321)
	var parts = input_text.split(":")
	var ip_address = parts[0]
	var connect_port = PORT # Default to your constant 42069
	
	if parts.size() > 1:
		connect_port = parts[1].to_int()
	
	var peer = ENetMultiplayerPeer.new()
	print("Connecting to ", ip_address, " on port ", connect_port)
	var error = peer.create_client(ip_address, connect_port)
	if error != OK:
		print("Failed to create client: ", error)
		return
		
	multiplayer.multiplayer_peer = peer
	
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	#request_players.rpc_id(1)

func _spawn_enemy(spawn_position: Vector2) -> void:
	var enemy = enemy_scene.instantiate()
	enemy.enemy_id = _enemy_id_counter
	# Name the node predictably for the MultiplayerSpawner
	enemy.name = "Enemy_" + str(abs(_enemy_id_counter)) 
	
	enemy.global_position = spawn_position
	
	_enemy_spawn_node.add_child(enemy)
	
	_enemy_id_counter -= 1 # Decrement so next enemy is -2, then -3, etc.
	
func _add_player(id):
	print("Player %s joined the game" % id)
	
	
	var player = player_scene.instantiate()
	# This player_id could probably be replaced. But tutorial did 
	# it this way and it works, so won't change it right now
	player.player_id = id
	player.name = str(id)
	_player_spawn_node.add_child(player)
	
	

func remove_player(id):
	print("Player %s disconnected" % id)
	var player = _player_spawn_node.get_node_or_null(str(id))
	if player:
		player.queue_free()
		
func _on_server_disconnected():
	get_tree().reload_current_scene()
	
