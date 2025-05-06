extends OptionButton
class_name AspectRationOptionButton

var possible_aspect_ratios : Array[Vector2i]

func _ready() -> void:
	
	item_selected.connect(_item_selected)
	
	var aspect_ratio_config : AspectRatioConfig = GameConfig.get_node("Video/AspectRatio")
	possible_aspect_ratios = aspect_ratio_config.get_available_aspect_ratios()
	
	var idx : int = 0
	for aspect_ratio in possible_aspect_ratios:
		idx += 1
		
		add_item(_vector2i_to_string(aspect_ratio), idx)

func _item_selected(idx: int) -> void:
	var curr_text = get_item_text(idx)
	var vec = _string_to_vector2i(curr_text)
	
	GameConfig.set_config("Video","AspectRatio", vec)

func _set_item(value: Vector2i) -> void:
	var idx = possible_aspect_ratios.find(value)

	select(idx)

func _string_to_vector2i(str: String) -> Vector2i:
	var split : PackedStringArray = str.split("x")
	return Vector2i(int(split[0]), int(split[1]))
	
func _vector2i_to_string(vec: Vector2i) -> String:
	return "%dx%d" % [vec.x, vec.y]
