extends AbstractConfig

func _default_value() -> Variant:
	return null
	
func is_valid(new_value: Variant) -> bool:
	return false

func apply() -> bool:
	return false
	
func to_json() -> Dictionary:
	return {
		"name" : name,
		"description" : description,
		"value" : value
	}
