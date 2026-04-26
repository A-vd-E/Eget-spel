extends Node2D

# Moved all the button logic here to separate from networking.
func _on_host_button_pressed() -> void:
	print("Host button pressed")
	toggle_ui(false)
	Network._become_host()
	pass

func _on_join_button_pressed() -> void:
	print("Join button pressed")
	var ip_input = get_node("CanvasLayer/VBoxContainer/LineEdit")
	
	toggle_ui(false)
	Network._join_as_non_host_client(ip_input.text)
	

func toggle_ui(show: bool):
	$CanvasLayer.visible = show
