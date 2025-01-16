extends OptionButton

const POSSIBLE_SCREEN_RESOLUTIONS : Array[Vector2i] = [
	Vector2i(1152, 648),
	Vector2i(1280, 720),
	Vector2i(1366, 768),
	Vector2i(1536, 864),
	Vector2i(1920, 1080),
	Vector2i(2560, 1440),
	Vector2i(3840, 2160)
]

func _ready() -> void:
	item_selected.connect(_item_selected)
	var screen_size : Vector2i = DisplayServer.screen_get_size()
	
	for resolution in POSSIBLE_SCREEN_RESOLUTIONS:
		if resolution <= screen_size:
			add_item("%dx%d" % [resolution.x, resolution.y])
	
func _resolution_string_to_vector(resolution_string : String) -> Vector2i:
	var values : PackedStringArray = resolution_string.split("x")
	return Vector2i(int(values[0]), int(values[1]))

func _item_selected(idx: int) -> void:
	var value : String = get_item_text(idx)
	var resolution : Vector2i = _resolution_string_to_vector(value)
	GameConfig.set_config("Video","resolution", resolution)

func _update_field_with_vector2i(value: Vector2i) -> void:
	print("resolution: ", value)
	var resolution_index : int = POSSIBLE_SCREEN_RESOLUTIONS.find(value)
	selected = resolution_index
