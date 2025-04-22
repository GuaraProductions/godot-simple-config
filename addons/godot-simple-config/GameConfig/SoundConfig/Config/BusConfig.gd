@tool
extends AbstractConfig
class_name BusConfig

@export var bus_index : int = 0 : 
	set(_bus_index):
		bus_index = _bus_index
		update_configuration_warnings()

func _get_configuration_warnings() -> PackedStringArray:
	var warnings := []
	
	if not bus_index:
		return warnings
	
	if not _bus_index_is_valid(bus_index):
		warnings.append("Erro! A audio track que você selecionou não existe")
		
	return warnings

func _bus_index_is_valid(idx: int) -> bool:
	return idx >= 0 and idx < AudioServer.bus_count

func _default_value() -> Variant:
	return 0
	
func is_valid(new_value: Variant) -> bool:
	return new_value >= -80 and new_value <= 6

func apply() -> bool:
	
	if not _bus_index_is_valid(bus_index):
		return false
		
	AudioServer.set_bus_volume_db(bus_index, value)
	
	return true
	
func to_json() -> Dictionary:
	return {
		"name" : name,
		"description" : description,
		"value" : value
	}
