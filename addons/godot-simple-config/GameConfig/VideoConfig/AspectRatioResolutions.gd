extends Resource
class_name AspectRatioResolutions

@export var aspect_ratio : Vector2i = Vector2i.ZERO
@export var resolutions : Array[Vector2i] = []

func _init(p_aspect_ratio : Vector2i = Vector2i.ZERO, 
		   p_resolutions : Array[Vector2i] = []) -> void:
	aspect_ratio = p_aspect_ratio
	resolutions = p_resolutions
	
