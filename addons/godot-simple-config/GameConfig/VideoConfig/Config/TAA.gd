extends AbstractConfig

func _default_value() -> Variant:
	return get_viewport().use_taa
	
func is_valid(new_value: Variant) -> bool:
	return new_value is bool

func apply() -> bool:
	get_viewport().use_taa = value
	return true
