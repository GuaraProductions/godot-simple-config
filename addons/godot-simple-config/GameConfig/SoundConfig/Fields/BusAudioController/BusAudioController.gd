extends HSlider

func _value_changed(new_value: float) -> void:
	GameConfig.set_config("Sound", "Master", new_value)
