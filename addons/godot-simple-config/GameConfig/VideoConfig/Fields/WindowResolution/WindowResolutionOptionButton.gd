extends OptionButton

var possible_resolutions : Array[Vector2i] = []

@export var aspect_ratio_option_button : OptionButton

func _ready() -> void:
	item_selected.connect(_item_selected)
	
	var aspect_ratio_config : AspectRatioConfig = GameConfig.get_node("Video/AspectRatio")
	possible_resolutions = aspect_ratio_config.get_possible_resolutions()
	
	for resolution in possible_resolutions:
		add_item(_vector2i_to_string(resolution))
		
	if aspect_ratio_option_button:
		aspect_ratio_option_button.item_selected.connect(_aspect_ratio_changed)
	
func _aspect_ratio_changed(idx: int) -> void:
	
	clear()
	
	var curr_text : String = aspect_ratio_option_button.get_item_text(idx)
	var vec : Vector2i = _string_to_vector2i(curr_text)
	
	var aspect_ratio_config : AspectRatioConfig = GameConfig.get_node("Video/AspectRatio")
	possible_resolutions = aspect_ratio_config.get_possible_resolutions(vec)
	
	for resolution in possible_resolutions:
		add_item(_vector2i_to_string(resolution))
	
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

func _vector2i_to_string(vec: Vector2i) -> String:
	return "%dx%d" % [vec.x, vec.y]
	
func _string_to_vector2i(str: String) -> Vector2i:
	var split : PackedStringArray = str.split("x")
	return Vector2i(int(split[0]), int(split[1]))
