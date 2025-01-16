extends AbstractConfig
class_name LanguageConfig

func _default_value() -> Variant:
	return OS.get_locale()
	
func is_valid(new_value: Variant) -> bool:
	return new_value is String \
	 and TranslationServer.get_loaded_locales().has(new_value)

func apply() -> bool:
	TranslationServer.set_locale(value)
	return TranslationServer.get_locale() == value
