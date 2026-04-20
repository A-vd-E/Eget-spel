extends Node

#const IP_ADDRESS: String = "localhost"
const PORT: int = 42069
var player_scene = preload("res://scenes/player.tscn")

@onready var world = get_node("../World")
@onready var host_button = get_node("../CanvasLayer/VBoxContainer/HostButton")
@onready var join_button = get_node("../CanvasLayer/VBoxContainer/JoinButton")
@onready var ip_input = get_node("../CanvasLayer/VBoxContainer/LineEdit")

func _on_host_button_pressed() -> void:
	host_button.hide()
	join_button.hide()
	ip_input.hide()
	
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	
	add_player(multiplayer.get_unique_id())
	

func _on_join_button_pressed() -> void:
	host_button.hide()
	join_button.hide()
	ip_input.hide()
	
	var ip_address = ip_input.text
	if ip_address == "":
		ip_address = "localhost"
	
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(ip_address, PORT)
	multiplayer.multiplayer_peer = peer
	
func add_player(id):
	var player = player_scene.instantiate()
	player.name = str(id)
	world.add_child(player)
