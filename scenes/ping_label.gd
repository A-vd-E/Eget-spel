extends Label

var update_timer: float = 0.0
@export var update_interval: float = 1.0 # Update every second

func _process(delta: float) -> void:
	# Only run if we are actually connected to a network
	if not multiplayer.has_multiplayer_peer():
		visible = false
		return
	
	update_timer += delta
	if update_timer >= update_interval:
		update_timer = 0.0
		_update_ping_display()

func _update_ping_display() -> void:
	# If we are the server (dedicated or host), ping is technically 0
	if multiplayer.is_server():
		text = "Ping: 0ms (Server)"
		visible = true # Or set to false if you don't want the server to see it
		return

	# We are a client. We want to see the latency to the server (ID 1)
	var peer = multiplayer.multiplayer_peer
	
	if peer is ENetMultiplayerPeer:
		# Peer 1 is always the server
		var server_peer = peer.get_peer(1)
		
		# ENet tracks RTT (Round Trip Time) automatically in milliseconds
		var rtt = server_peer.get_statistic(ENetPacketPeer.PEER_ROUND_TRIP_TIME)
		
		text = "Ping: %dms" % rtt
		visible = true
		
		# Optional: Change color based on ping
		if rtt < 60:
			modulate = Color.GREEN
		elif rtt < 150:
			modulate = Color.YELLOW
		else:
			modulate = Color.RED
	else:
		visible = false
