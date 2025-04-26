extends GridContainer

@export var button_bind_screen : PackedScene
@export var binding_config_name : String = ""
@export var num_configs : int = 1

var selecting_input: bool = false

var binding_manager : BindingManager

func _ready() -> void:

	num_configs = clamp(num_configs, 1, 5)

	columns = num_configs + 1

	binding_manager = GameConfig.get_node("Binding")

	var actions = binding_manager.get_bindings(binding_config_name)
	#print("array_actions: ", actions)
	
	for i in range(num_configs):
		var label = Label.new()
		label.text = "%d_input" % [i+1]
		
		add_child(label)
	

	for action in actions:
		var label = Label.new()
		label.text = action
		
		add_child(label)

		var event_list : Array[InputEvent] = actions[action]
		
		if not event_list.is_empty():
			
			for idx in range(clamp(event_list.size(), 1, num_configs)):

				var event = event_list[idx]
				var bind_button = Button.new()
				
				if event is InputEventJoypadButton \
					or event is InputEventMouseButton \
					or event is InputEventJoypadMotion:
					bind_button.text = ""
				else:
					var action_keycode : int = event.keycode
					var keystring : String = OS.get_keycode_string(action_keycode)
					bind_button.text = keystring
			
				bind_button.pressed.connect(
					_select_input_for_action.bind(action, event,bind_button))
				
				add_child(bind_button)
				
			_add_empty_button(action, num_configs - event_list.size())
		else:
			_add_empty_button(action, num_configs)
				
func _add_empty_button(action: StringName, num_buttons: int) -> void:
	for i in range(num_buttons):
		
		var bind_button = Button.new()
		bind_button.pressed.connect(
			_select_input_for_action.bind(action, null,bind_button))
		
		add_child(bind_button)

func _select_input_for_action(action: StringName, 
							  previous_event: InputEvent,
							  button: Button) -> void:
						
	if selecting_input:
		return

	selecting_input = true

	var instancia_button_binder = button_bind_screen.instantiate()
	
	get_tree().root.add_child.call_deferred(instancia_button_binder)
	
	var result : Dictionary = await instancia_button_binder.operation_finished
	
	if _result_dictionary_is_valid(result):
		binding_manager.set_binding("Player1", 
		{
			"action" : action, "event" : result.key, "previous_event" : previous_event
		})
		button.text = str(OS.get_keycode_string(result.key.keycode))
		
	get_tree().root.remove_child(instancia_button_binder)
	
	selecting_input = false
	
	instancia_button_binder.queue_free()


func _result_dictionary_is_valid(dict: Dictionary) -> bool:
	return dict is Dictionary \
	 and dict.has("success") \
	 and dict.has("key") \
	 and dict.success
