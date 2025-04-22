extends CheckBox

func _toggled(toggled_on: bool) -> void:
	var new_vsync_value : int = DisplayServer.VSYNC_ENABLED \
	 if toggled_on \
	 else DisplayServer.VSYNC_DISABLED
	
	GameConfig.set_config("Video", "VSync", new_vsync_value)
