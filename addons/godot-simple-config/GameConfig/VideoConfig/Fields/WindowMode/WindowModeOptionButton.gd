extends OptionButton

func _ready() -> void:
	
	item_selected.connect(_item_selected)

	for i in item_count:
		var text : String = get_item_text(i)
		set_item_text(i, tr(text))

func _item_selected(idx: int) -> void:
	GameConfig.set_config("Video","WindowMode", idx)
