extends OptionButton

func _ready() -> void:
	item_selected.connect(_item_selected)
	
func _item_selected(idx: int) -> void:
	var id : int = get_item_id(idx)
	GameConfig.set_config("Video", "ScalingMode", id)

func _select_item(id: int) -> void:
	var idx : int = get_item_index(id)
	select(idx)
