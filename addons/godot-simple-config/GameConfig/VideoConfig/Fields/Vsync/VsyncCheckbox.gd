extends CheckBox

func _toggled(toggled_on: bool) -> void:
	GameConfig.set_config("Video", "vsync", DisplayServer.VSYNC_ENABLED if toggled_on else DisplayServer.VSYNC_DISABLED)
