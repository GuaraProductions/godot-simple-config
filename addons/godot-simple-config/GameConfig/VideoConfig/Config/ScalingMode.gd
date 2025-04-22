extends AbstractConfig
class_name ScalingMode

func _default_value() -> Variant:
	return Viewport.SCALING_3D_MODE_BILINEAR
	
func is_valid(new_value: Variant) -> bool:
	return new_value is int and new_value >= Viewport.SCALING_3D_MODE_BILINEAR and new_value <= Viewport.SCALING_3D_MODE_MAX 

func apply() -> bool:
	get_tree().root.scaling_3d_mode = value
	
	return get_tree().root.scaling_3d_mode == value
