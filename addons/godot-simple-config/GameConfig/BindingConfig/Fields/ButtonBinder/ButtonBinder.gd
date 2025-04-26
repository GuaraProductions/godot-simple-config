extends ColorRect

signal operation_finished(dict: Dictionary)

@onready var instruction_label : Label = %InstructingLabel
@onready var key_pressed_label : Label = %KeyPressedLabel
@onready var ok_button : Button = %Ok
@onready var reset_button : Button = %Reset

var pressed_key : InputEvent

func _ready() -> void:
	key_pressed_label.visible = false
	ok_button.visible = false
	reset_button.visible = false

func _on_cancel_pressed() -> void:
	operation_finished.emit(
		{
			"success": false
		}
	)

func _on_ok_pressed() -> void:
	operation_finished.emit(
		{
			"success" : true,
			"key" : pressed_key
		}
	)
	
func _input(event: InputEvent) -> void:
	
	if event is InputEventMouseMotion:
		return
	
	if event.is_pressed():
		player_pressed_key(event)
	
func player_pressed_key(event: InputEvent) -> void:
	
	set_process_input(false)
	
	ok_button.visible = true
	key_pressed_label.visible = true
	
	instruction_label.text = "Você pressionou a tecla"
	
	pressed_key = event
	
	if event is InputEventMouseButton:
		key_pressed_label.text = str(mouse_button_index_to_string(event.button_index))
	elif event is InputEventKey:
		key_pressed_label.text = str(OS.get_keycode_string(event.keycode))
		
	reset_button.visible = true


func _on_reset_pressed() -> void:
	instruction_label.text = "Digite a tecla"
	key_pressed_label.visible = false
	ok_button.visible = false
	pressed_key = null
	set_process_input(true)

func mouse_button_index_to_string(idx: int) -> String:

	var key : String = "NOT_IDENTIFIED"

	match idx:
		MOUSE_BUTTON_NONE:
			key = "MOUSE_BUTTON_NONE"
		MOUSE_BUTTON_LEFT:
			key = "MOUSE_BUTTON_LEFT"
		MOUSE_BUTTON_RIGHT:
			key = "MOUSE_BUTTON_RIGHT"
		MOUSE_BUTTON_MIDDLE:
			key = "MOUSE_BUTTON_MIDDLE"
		MOUSE_BUTTON_WHEEL_UP:
			key = "MOUSE_BUTTON_WHEEL_UP"
		MOUSE_BUTTON_WHEEL_DOWN:
			key = "MOUSE_BUTTON_WHEEL_DOWN"
		
	return key
