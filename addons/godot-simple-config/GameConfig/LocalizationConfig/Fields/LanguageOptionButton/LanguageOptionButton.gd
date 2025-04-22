extends OptionButton

func _ready() -> void:
	item_selected.connect(_item_selected)
	
	var possible_locales = TranslationServer.get_loaded_locales()
	
	for locale in possible_locales:
		add_item("%s" % [locale])

func _item_selected(idx: int) -> void:
	var value : String = get_item_text(idx)
	GameConfig.set_config("Language","PrimaryLanguage", value)
