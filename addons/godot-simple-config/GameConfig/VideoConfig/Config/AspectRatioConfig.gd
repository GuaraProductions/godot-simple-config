extends AbstractConfig
class_name AspectRatioConfig

@export var allow_downsampling : bool = false
@export var possible_resolutions : Array[AspectRatioResolutions]

func _default_value() -> Variant:
	var screen_resolution : Vector2i = DisplayServer.screen_get_size()
	return _calculate_aspect_ratio(screen_resolution.x, screen_resolution.y)
	
func is_valid(new_value: Variant) -> bool:
	return new_value is Vector2i

func apply() -> bool:
	return false

func _get_aspect_ratio_for_resolution(aspect_ratio: Vector2i) -> Array[Vector2i]:
	
	var resolutions : Array[Vector2i] = []

	for resolution in possible_resolutions:
		if aspect_ratio != resolution.aspect_ratio:
			continue
			
		resolutions = resolution.resolutions
		break
		
	return resolutions
		
func _calculate_aspect_ratio(a: int, 
							b: int) -> Vector2i:
	
	var tmp_a = a
	var tmp_b = b
	
	a = abs(a)
	b = abs(b)
	
	while b != 0:
		var temp : int = b
		b = a % b
		a = temp
		
	return Vector2i(tmp_a / a, tmp_b / a)
	
func get_available_aspect_ratios() -> Array[Vector2i]:
	var result : Array[Vector2i] = []
	
	for resolution in possible_resolutions:
		result.append(resolution.aspect_ratio)
		
	return result
	
func get_possible_resolutions(aspect_ratio : Vector2i = Vector2i.ZERO) -> Array[Vector2i]:
	
	if aspect_ratio == Vector2i.ZERO:
		aspect_ratio = value
	
	var resolutions : Array[Vector2i] = []
	var screen_size : Vector2i = DisplayServer.screen_get_size()

	var available_resolutions : Array[Vector2i] = _get_aspect_ratio_for_resolution(aspect_ratio)

	if allow_downsampling:
		return available_resolutions

	for resolution in available_resolutions:
		if resolution > screen_size:
			continue
			
		resolutions.append(resolution)
	
	resolutions.sort()
	
	return resolutions
