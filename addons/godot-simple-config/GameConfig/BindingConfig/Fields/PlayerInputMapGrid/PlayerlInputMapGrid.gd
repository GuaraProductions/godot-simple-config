extends GridContainer

@export var button_bind_screen : PackedScene
@export var place_default_actions : bool = false

func _ready() -> void:

	var actions = InputMap.get_actions()

	for action in actions:
		var label = Label.new()
		label.text = action
		
		add_child(label)
		
		var default_action_button = Button.new()
		default_action_button.text = ""
		default_action_button.pressed.connect(
			_select_input_for_action.bind(action,true))
		
		add_child(default_action_button)
		
		var secondary_action_button = Button.new()
		secondary_action_button.text = ""
		secondary_action_button.pressed.connect(
			_select_input_for_action.bind(action,false))
		
		add_child(secondary_action_button)
		
func _select_input_for_action(action: StringName, 
								default: bool) -> void:
									
	var instancia_button_binder = button_bind_screen.instantiate()
	
	get_tree().root.add_child.call_deferred(instancia_button_binder)
	
	var result : Dictionary = await instancia_button_binder.operation_finished
	
	print("terminou: ", result)
	
	get_tree().root.remove_child(instancia_button_binder)
	instancia_button_binder.queue_free()

	
