extends AbstractConfig

@export_enum("2D","3D","Both") var msaa_type : int

func _default_value() -> Variant:
	var default : int = ProjectSettings.get_setting("rendering/anti_aliasing/quality/msaa_2d", Viewport.MSAA_DISABLED)
	if msaa_type == 2:
		default = ProjectSettings.get_setting("rendering/anti_aliasing/quality/msaa_3d", Viewport.MSAA_DISABLED)

	return default
	
func is_valid(new_value: Variant) -> bool:
	return new_value is int \
	 and new_value >= Viewport.MSAA_DISABLED \
	 and new_value <= Viewport.MSAA_8X

func apply() -> bool:
	match msaa_type:
		0:
			_change_msaa_2d(value)
		1:
			_change_msaa_3d(value)
		2:
			_change_msaa_3d(value)
			_change_msaa_2d(value)
			
	return true

func _change_msaa_2d(index: int) -> void:
	match index:
		0: get_viewport().msaa_3d = Viewport.MSAA_DISABLED
		1: get_viewport().msaa_3d = Viewport.MSAA_2X
		2: get_viewport().msaa_3d = Viewport.MSAA_4X
		3: get_viewport().msaa_3d = Viewport.MSAA_8X

func _change_msaa_3d(index: int) -> void:
	match index:
		0: get_viewport().msaa_2d = Viewport.MSAA_DISABLED
		1: get_viewport().msaa_2d = Viewport.MSAA_2X
		2: get_viewport().msaa_2d = Viewport.MSAA_4X
		3: get_viewport().msaa_2d = Viewport.MSAA_8X
