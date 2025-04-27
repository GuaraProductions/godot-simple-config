extends Node
class_name ScreenshotHandler

## O proprio node ira verificar se a tecla de tirar screenshot for pressionada
@export var handle_screenshot : bool = true : set = _set_handle_screenshot
@export var folder_name : String = "Screenshots"
@export var screenshot_game_action : StringName = "ui_screenshot"

func _set_handle_screenshot(value: bool) -> void:
	handle_screenshot = value
	set_process_unhandled_key_input(handle_screenshot and \
								   InputMap.has_action(screenshot_game_action))
	
func _ready() -> void:
	
	var screenshot_folder : String = "user://%s" % folder_name
	
	if not DirAccess.dir_exists_absolute(screenshot_folder):
		DirAccess.make_dir_absolute(screenshot_folder)
		
	var can_process_screenshot = handle_screenshot and InputMap.has_action(screenshot_game_action)
   
	set_process_unhandled_key_input(can_process_screenshot)
	
	if not InputMap.has_action(screenshot_game_action):
		printerr("Comando para ativar screenshot não foi configurado")

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed(screenshot_game_action):
		_take_screenshot_from_viewport()

func _take_screenshot_from_viewport() -> void:

	var capture = get_viewport().get_texture().get_image()
	var _time = Time.get_date_string_from_system()
	var filename = "user://%s/%s-%s.png" % [folder_name, tr("Screenshot"), _time]
	
	var file : FileAccess = FileAccess.open(filename, FileAccess.WRITE)
	
	if file == null:
		printerr("Nao foi possivel abrir arquivo!")
		printerr("Motivo: ", FileAccess.get_open_error())
		printerr("Nome arquivo: ", filename)
		return
	
	var buffer = capture.save_png_to_buffer()
	
	file.store_buffer(buffer)
	
	file.close()
