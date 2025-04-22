extends ConfigManager
class_name VideoManager

const RESOLUTIONS : Array[Vector2i] = [
	Vector2i(1280,720),
	Vector2i(1920,1080),
	Vector2i(2560,1440),
	Vector2i(3840,2160)
]

func get_possible_resolutions() -> Array[Vector2i]:
	return RESOLUTIONS
