extends Node
class_name ConfigManager

## Gerencia um grupo seleto de configuracoes dentro de uma lista

var configs: Dictionary[String, Node] = {}

func _ready() -> void:
	
	## Ignorar execucao dessa funcao se tiver dentro do Editor
	if Engine.is_editor_hint():
		return
		
	# Inicia a varredura a partir deste nó
	_scan_for_configs()
		
# Função recursiva que busca AbstractConfig em node e seus descendentes
func _scan_for_configs(node: Node = self) -> void:
	for child in node.get_children(true):
		# Se o filho for do tipo AbstractConfig, registra no dicionário
		if child is AbstractConfig:
			# Evita sobrescrever caso haja nomes duplicados; você pode ajustar conforme necessário
			if configs.has(child.name):
				push_warning("Já existe um AbstractConfig com nome '%s' em '%s'" % [child.name, child.get_path()])
			else:
				configs[child.name] = child
				
		if child.get_child_count(false) > 0:
			_scan_for_configs(child)
			

## Acessar as informacoes internas de uma configuracao, a partir de seu id [config]
func get_config_by_id(config: String) -> Dictionary:
	
	if not configs.has(config):
		return {}
	
	return configs[config].to_json()
	
## Retornar todas as configuracoes em formato JSON 
func get_configs() -> Dictionary:
	
	var result : Dictionary = {}
	for config_name in configs.keys():
		var config : AbstractConfig = configs[config_name]
		result[config_name] = config.to_json()
	return result
	
## Aplicar todas as configuracoes, se existir
func apply_configs(first_time: bool = false) -> void:
	for config_name in configs.keys():
		var config : AbstractConfig = configs[config_name]
			
		config.try_to_apply(first_time)

## Conectar a chamada do sinal `applied` a uma configuracao
func connect_config_applied_to_callable(config: String, 
										callable: Callable,
										flags: int) -> bool:
	var connected : bool = false
	
	if not configs.has(config):
		return connected
		
	var config_node : AbstractConfig = configs[config]

	if not config_node.applied.is_connected(callable):
		config_node.applied.connect(callable, flags)
		
	connected = true
		
	return connected

## Atribuir um novo valor a uma configuracao
func set_config(config: String, 
				value: Variant,
				apply_after_set: bool) -> bool:
	
	var found : bool = false
	
	if not configs.has(config):
		return found
		
	var config_node : AbstractConfig = configs[config]
			
	config_node.value = value
	found = config_node.value == value
	
	if found and apply_after_set:
		config_node.try_to_apply()
		
	return found

## Configuracao em massa de todas as configuracoes
func set_configs(dict: Dictionary) -> bool:
	for config_name in configs.keys():
		var config : AbstractConfig = configs[config_name]
		if not dict.has(config_name):
			continue
		
		var value = str_to_var(dict[config_name])
		config.value = value
		
	return true
