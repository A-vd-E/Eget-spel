extends Node2D

func _ready() -> void:
	# If launched with the feature tag or --server argument, start dedicated server automatically
	if OS.has_feature("dedicated_server") or "--server" in OS.get_cmdline_args():
		print("Starting Dedicated Server...")
		toggle_ui(false)
		# Pass 'true' to indicate this is a dedicated server
		Network._become_host(true)

# Moved all the button logic here to separate from networking.
func _on_host_button_pressed() -> void:
	print("Host button pressed")
	toggle_ui(false)
	# Pass false to indicate this is a Host (Server + Player), not a Dedicated Server
	Network._become_host(false)

func _on_join_button_pressed() -> void:
	print("Join button pressed")
	var ip_input = get_node("CanvasLayer/VBoxContainer/LineEdit")
	
	toggle_ui(false)
	Network._join_as_non_host_client(ip_input.text)
	

func toggle_ui(show: bool):
	$CanvasLayer/VBoxContainer.visible = show
