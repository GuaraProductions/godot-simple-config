extends AbstractConfig
class_name LanguageConfig

@export var default_locale : String = ""

func _has_locale(locale: String) -> bool:
	return TranslationServer.get_loaded_locales().has(locale)

func _default_value() -> Variant:
	return default_locale \
	 if _has_locale(default_locale) \
	 else OS.get_locale()
	
func is_valid(new_value: Variant) -> bool:
	return new_value is String \
	 and _has_locale(new_value)

func apply() -> bool:
	TranslationServer.set_locale(value)
	return TranslationServer.get_locale() == value
