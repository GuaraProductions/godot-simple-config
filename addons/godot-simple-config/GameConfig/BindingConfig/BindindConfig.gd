extends ConfigManager
class_name BindingManager

func get_bindings(config: String) -> Dictionary:
	
	var found : bool = false
	
	if not configs.has(config):
		return {}
		
	var config_node : AbstractConfig = configs[config]

	return config_node.value

## Atribuir um novo valor a uma configuracao
func set_binding(config: String, 
				binding: Variant,
				apply_after_set: bool = false) -> bool:
	
	var found : bool = false
	
	if not configs.has(config):
		return false
		
	var config_node : AbstractConfig = configs[config]
			
	config_node.append_binding(binding)
	found = true
	
	if found and apply_after_set:
		config_node.try_to_apply()
		
	return found

static func get_keycodes_from_action(action: StringName) -> Array[String]:
	
	var keycodes : Array[String] = []
	
	var action_event_list : Array[InputEvent] = InputMap.action_get_events(action)

	for action_event in action_event_list:
		var action_keycode : int = action_event.keycode
		var keystring : String = OS.get_keycode_string(action_keycode)
		
		keycodes.append(keystring)
	
	return keycodes
