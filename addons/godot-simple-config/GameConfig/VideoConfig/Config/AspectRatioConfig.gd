extends AbstractConfig
class_name AspectRatioConfig

@export var allow_downsampling : bool = false
@export var possible_resolutions : Array[AspectRatioResolutions]

func _default_value() -> Variant:
	return null
	
func is_valid(new_value: Variant) -> bool:
	return false

func apply() -> bool:
	return false

func get_aspect_ratio_for_resolution(screen_resolution: Vector2i) -> Array[Vector2i]:
	
	var aspect_ratio : Vector2i = calculate_aspect_ratio(screen_resolution.x, screen_resolution.y)
	var resolutions : Array[Vector2i] = []

	for resolution in possible_resolutions:
		if aspect_ratio != resolution.aspect_ratio:
			continue
			
		resolutions = resolution.resolutions
		break
		
	return resolutions
		
func calculate_aspect_ratio(a: int, 
							b: int) -> Vector2i:
	
	var tmp_a = a
	var tmp_b = b
	
	a = abs(a)
	b = abs(b)
	
	while b != 0:
		var temp : int = b
		b = a % b
		a = temp
		
	return Vector2i(tmp_a / a, tmp_b / b)
	
func get_possible_resolutions() -> Array[Vector2i]:
	var resolutions : Array[Vector2i] = []
	var screen_size : Vector2i = DisplayServer.screen_get_size()

	var available_resolutions : Array[Vector2i] = get_aspect_ratio_for_resolution(screen_size)

	if allow_downsampling:
		return available_resolutions

	for resolution in available_resolutions:
		if resolution > screen_size:
			continue
			
		resolutions.append(resolution)
	
	resolutions.sort()
	
	return resolutions
