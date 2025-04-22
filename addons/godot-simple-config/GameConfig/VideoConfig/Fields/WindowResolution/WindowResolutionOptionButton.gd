extends OptionButton

var possible_resolutions : Array[Vector2i] = []

func _ready() -> void:
	item_selected.connect(_item_selected)
	
	var video_manager : VideoManager = GameConfig.get_node("Video")
	
	possible_resolutions = video_manager.get_possible_resolutions()
	
	for resolution in possible_resolutions:
		add_item("%dx%d" % [resolution.x, resolution.y])
	
func _resolution_string_to_vector(resolution_string : String) -> Vector2i:
	var values : PackedStringArray = resolution_string.split("x")
	return Vector2i(int(values[0]), int(values[1]))

func _item_selected(idx: int) -> void:
	var value : String = get_item_text(idx)
	var resolution : Vector2i = _resolution_string_to_vector(value)
	GameConfig.set_config("Video","Resolution", resolution)

func _update_field_with_vector2i(value: Vector2i) -> void:
	var resolution_index : int = possible_resolutions.find(value)
	selected = resolution_index
