extends ColorRect

signal operation_finished(dict: Dictionary)

func _on_cancel_pressed() -> void:
	operation_finished.emit({"cancel": true})

func _on_ok_pressed() -> void:
	operation_finished.emit({"success" : true})
