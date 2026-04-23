extends Node

const PORT: int = 42069
var player_scene = preload("res://scenes/player.tscn")

@onready var world = get_node("../World")
@onready var host_button = get_node("../CanvasLayer/VBoxContainer/HostButton")
@onready var join_button = get_node("../CanvasLayer/VBoxContainer/JoinButton")
@onready var ip_input = get_node("../CanvasLayer/VBoxContainer/LineEdit")

func _ready():
	multiplayer.peer_disconnected.connect(remove_player)
	multiplayer.server_disconnected.connect(_on_server_disconnected)

func _on_host_button_pressed() -> void:
	toggle_ui(false)
	
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	
	add_player(multiplayer.get_unique_id())
	
func _on_join_button_pressed() -> void:
	toggle_ui(false)
	
	var input_text = ip_input.text
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
	
func add_player(id):
	var player = player_scene.instantiate()
	player.name = str(id)
	world.add_child(player)
	
func remove_player(id):
	var player = world.get_node_or_null(str(id))
	if player:
		player.queue_free()
		
func _on_server_disconnected():
	get_tree().reload_current_scene()
	
func toggle_ui(show: bool):
	host_button.visible = show
	join_button.visible = show
	ip_input.visible = show
