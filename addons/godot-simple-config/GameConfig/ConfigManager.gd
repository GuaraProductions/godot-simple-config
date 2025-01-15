extends Node
class_name ConfigManager

## Gerencia um grupo seleto de configuracoes dentro de uma lista

## Uma lista de configuracoes abstratas
@export var configs : Array[AbstractConfig] = []
## Nome do grupo de cena a ser adicionado
const GROUP_NAME : String = "Config"

var config_ids_and_index : Dictionary = {}

func _ready() -> void:
	
	## Ignorar execucao dessa funcao se tiver dentro do Editor
	if Engine.is_editor_hint():
		return
	
	if not is_in_group(GROUP_NAME):
		add_to_group(GROUP_NAME)
		
	## Indexar configuracoes, aos seus ids na lista
	var idx : int = 0
	for curr in configs:
		config_ids_and_index[curr.id] = idx
		idx += 1

## Acessar as informacoes internas de uma configuracao, a partir de seu id [config]
func get_config_by_id(config: String) -> Dictionary:
	var config_found := {}
	
	var idx : int = config_ids_and_index.get(config, -1)
	
	if idx == -1:
		return config_found
		
	return configs[idx].to_json()
	
## Retornar todas as configuracoes em formato JSON 
func get_configs() -> Dictionary:
	var result : Dictionary = {}
	for curr in configs:
		result[curr.id] = curr.to_json()
	return result
	
## Aplicar todas as configuracoes, se existir
func apply_configs() -> void:
	for curr in configs:
		if curr == null:
			continue
		curr.try_to_apply()

## Conectar a chamada do sinal `applied` a uma configuracao
func connect_config_applied_to_callable(config: String, 
										callable: Callable,
										flags: int) -> bool:
	var connected : bool = false
	
	var idx : int = config_ids_and_index.get(config, -1)
	
	if idx == -1:
		return connected
		
	connected = true
		
	if not configs[idx].applied.is_connected(callable):
		configs[idx].applied.connect(callable, flags)
		
	return connected

## Atribuir um novo valor a uma configuracao
func set_config(config: String, value: Variant) -> bool:
	
	var found : bool = false
	
	var idx : int = config_ids_and_index.get(config, -1)
	
	if idx == -1:
		return found
			
	configs[idx].value = value
	found = configs[idx].value == value
		
	return found

## Configuracao em massa de todas as configuracoes
func set_configs(dict: Dictionary) -> bool:
	for curr in configs:
		if not dict.has(curr.id):
			continue
		
		var value = str_to_var(dict[curr.id])
		curr.value = value
		
	return true
