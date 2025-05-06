extends AbstractConfig

func _default_value() -> Variant:
	return Viewport.SCREEN_SPACE_AA_DISABLED
	
func is_valid(new_value: Variant) -> bool:
	return new_value is int \
	and new_value >= Viewport.SCREEN_SPACE_AA_DISABLED \
	and new_value <= Viewport.SCREEN_SPACE_AA_FXAA

func apply() -> bool:
	get_viewport().screen_space_aa = value
	return true
