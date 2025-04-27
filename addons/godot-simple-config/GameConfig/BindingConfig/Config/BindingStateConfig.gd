extends AbstractConfig
class_name BindingStateConfig

@export var actions_prefixes : Array[String] 

func _default_value() -> Variant:
	return {}
	
func is_valid(new_value: Variant) -> bool:
	return new_value is Dictionary

func _set_value(new_value: Variant) -> void:
	if is_valid(new_value):
		if not value:
			value = {}
			
		value = new_value
		
func append_binding(binding_info: Dictionary) -> void:
	if _is_valid_binding_info(binding_info):
		
		if not binding_info.previous_event:
			value[binding_info.action].append(binding_info.event)
		
		var idx : int = value[binding_info.action].find(binding_info.previous_event)
		if idx != -1:
			value[binding_info.action].erase(binding_info.previous_event)
			value[binding_info.action].insert(idx, binding_info.event)

func _is_valid_binding_info(binding_info: Dictionary) -> bool:
	return binding_info.has("action") \
	 and binding_info.has("event") \
	 and binding_info.has("previous_event")

func first_apply() -> bool:
	
	if not value or (value and value.is_empty()):
		_setup_action_events()
	else:
		var actions = value.keys() 
		actions = actions.filter(_filter_excluded_actions)
		
		var all_actions = InputMap.get_actions()
		all_actions = all_actions.filter(_filter_present_actions)
		
		if not actions.is_empty() or value.keys().size() != all_actions.size():
			value = {}

			for action in all_actions:
				value[action] = InputMap.action_get_events(action)
			
	return true

func _setup_action_events() -> void:
	value = {}
	
	var all_actions = InputMap.get_actions()
	all_actions = all_actions.filter(_filter_present_actions)
	
	for action in all_actions:
		value[action] = InputMap.action_get_events(action)	

func apply() -> bool:
	
	for action in value:
		InputMap.action_erase_events(action)
		var events = value[action]
		for event in events:
			InputMap.action_add_event(action, event)
		
	return true
	
func to_json() -> Dictionary:
	return {
		"name" : name,
		"description" : description,
		"value" : value
	}

func _filter_present_actions(action: StringName) -> bool:
	var contains_prefix : bool = false
	for prefix in actions_prefixes:
		contains_prefix = prefix in action
		if contains_prefix:
			break
			
	return contains_prefix
	
func _filter_excluded_actions(action: StringName) -> bool:
	var contains_prefix : bool = false
	for prefix in actions_prefixes:
		contains_prefix = prefix not in action
		if contains_prefix:
			break
			
	return contains_prefix
