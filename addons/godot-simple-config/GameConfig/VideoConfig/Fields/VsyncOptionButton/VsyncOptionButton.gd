extends OptionButton

func _ready() -> void:
	item_selected.connect(_item_selected)

func _item_selected(idx: int) -> void:
	var value = get_item_id(idx)
	GameConfig.set_config("Video", "VSync", value)

func _set_item(id: int) -> void:
	var idx: int = get_item_index(id)
	select(idx)
