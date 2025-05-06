extends AbstractConfig

func _default_value() -> Variant:
	return 1.0
	
func is_valid(new_value: Variant) -> bool:
	return new_value is float \
	and new_value > 0 \
	and new_value < 3

func apply() -> bool:
	get_viewport().set_scaling_3d_scale(value)
	return true
